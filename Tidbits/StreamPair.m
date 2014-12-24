//
//  StreamPair.m
//  Tidbits
//
//  Created by Ewan Mellor on 6/22/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <errno.h>

#import "StreamPair.h"


//#define DUMP_ALL 1

#ifdef DUMP_ALL
#import "NSData+Base64.h"
#endif


@interface StreamPairInputStream : NSInputStream

-(instancetype)init:(StreamPair*)streamPair;

@end


@interface StreamPairOutputStream : NSOutputStream

-(instancetype)init:(StreamPair*)streamPair;

@property (nonatomic) NSError * lastError;

@end


@implementation StreamPair {
    /**
     * Protects all access to buffer, isInputClosed, isOutputClosed.
     */
    NSCondition* condition;

    NSMutableArray* buffer;
    BOOL isInputClosed;
    BOOL isOutputClosed;
}


+(void)getStreamPairInput:(NSInputStream**)istream andOutput:(NSOutputStream**)ostream {
    StreamPair* sp = [[StreamPair alloc] init];
    *istream = [[StreamPairInputStream alloc] init:sp];
    *ostream = [[StreamPairOutputStream alloc] init:sp];
}


-(instancetype)init {
    self = [super init];
    if (self) {
        buffer = [NSMutableArray array];
        condition = [[NSCondition alloc] init];
    }
    return self;
}


-(NSInteger)read:(uint8_t *)destbuf maxLength:(NSUInteger)destlen {

    NSInteger n;

    [condition lock];

    while (true) {
        if (isInputClosed) {
            n = -1;
            break;
        }
        if (buffer.count == 0) {
            if (isOutputClosed) {
                n = 0;
                break;
            }
            else {
                [condition wait];
                continue;
            }
        }

        NSData* data = buffer[0];
        NSUInteger data_len = data.length;
        if (data_len <= destlen) {
            n = data_len;
            [buffer removeObjectAtIndex:0];
        }
        else {
            n = destlen;
            buffer[0] = [data subdataWithRange:NSMakeRange(n, data_len - n)];
        }
        [data getBytes:destbuf length:n];
        break;
    }

    [condition unlock];

    return n;
}


-(NSInteger)write:(const uint8_t *)srcbuf maxLength:(NSUInteger)srclen error:(NSError * __autoreleasing *)error {
    [condition lock];
    NSInteger result = [self write_:srcbuf maxLength:srclen error:error];
    [condition broadcast];
    [condition unlock];
    return result;
}

-(NSInteger)write_:(const uint8_t *)srcbuf maxLength:(NSUInteger)srclen error:(NSError * __autoreleasing *)error {
    if (isOutputClosed) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EPIPE userInfo:nil];
        }
        return -1;
    }

    [buffer addObject:[NSData dataWithBytes:srcbuf length:srclen]];

#if DUMP_ALL
    NSLog(@"DATA BLOCK: %@", [[NSData dataWithBytes:srcbuf length:srclen] base64EncodedString]);
#endif

    return srclen;
}


-(BOOL)hasBytesAvailable {
    BOOL result;
    [condition lock];
    result = buffer.count > 0;
    [condition unlock];
    return result;
}


-(NSStreamStatus)streamStatus:(BOOL)isInputStream {
    [condition lock];
    NSStreamStatus result = [self streamStatus_:isInputStream];
    [condition unlock];
    return result;
}

-(NSStreamStatus)streamStatus_:(BOOL)isInputStream {
    if (isInputClosed) {
        return NSStreamStatusClosed;
    }
    if (isOutputClosed) {
        if (isInputStream) {
            return (buffer.count == 0) ? NSStreamStatusAtEnd : NSStreamStatusOpen;
        }
        else {
            return NSStreamStatusClosed;
        }
    }

    return NSStreamStatusOpen;
}


-(void)closeOutput {
    [condition lock];
    isOutputClosed = YES;
    [condition broadcast];
    [condition unlock];
}


-(void)closeInput {
    [condition lock];
    isInputClosed = YES;
    isOutputClosed = YES;
    [condition broadcast];
    [condition unlock];
}


@end


@implementation StreamPairInputStream {
    StreamPair* streamPair;
}


-(instancetype)init:(StreamPair *)streamPair_ {
    self = [super init];
    if (self) {
        streamPair  = streamPair_;
    }
    return self;
}


-(void)open {
}


-(void)close {
    [streamPair closeInput];
}


-(NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len {
    return [streamPair read:buffer maxLength:len];
}


-(BOOL)getBuffer:(uint8_t **)buffer length:(NSUInteger *)len {
    return NO;
}


-(BOOL)hasBytesAvailable {
    return [streamPair hasBytesAvailable];
}


-(NSStreamStatus)streamStatus {
    return [streamPair streamStatus:YES];
}


-(NSError *)streamError {
    return nil;
}


-(void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {
    NSAssert(false, @"Not implemented");
}


-(void)removeFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {
    NSAssert(false, @"Not implemented");
}


@end


@implementation StreamPairOutputStream {
    StreamPair* streamPair;
}


-(instancetype)init:(StreamPair *)streamPair_ {
    self = [super init];
    if (self) {
        streamPair  = streamPair_;
    }
    return self;
}


-(void)open {
}


-(void)close {
    [streamPair closeOutput];
}


-(NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)len {
    NSError * err = nil;
    NSInteger result = [streamPair write:buffer maxLength:len error:&err];
    if (result == -1) {
        self.lastError = err;
    }
    return result;
}


-(BOOL)hasSpaceAvailable {
    return true;
}


-(NSStreamStatus)streamStatus {
    return [streamPair streamStatus:NO];
}


-(NSError *)streamError {
    return self.lastError;
}


-(void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {
}


-(void)removeFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {
}


@end
