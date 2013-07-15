//
//  StreamPair.m
//  Tidbits
//
//  Created by Ewan Mellor on 6/22/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

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

@end


@implementation StreamPair {
    /*!
     * Protects all access to buffer, closed, eof.
     */
    NSCondition* condition;

    NSMutableArray* buffer;
    bool closed;
    bool eof;
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
        if (closed) {
            n = -1;
            break;
        }
        if (eof && buffer.count == 0) {
            n = 0;
            break;
        }
        if (buffer.count == 0) {
            [condition wait];
            continue;
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


-(NSInteger)write:(const uint8_t *)srcbuf maxLength:(NSUInteger)srclen {
    [condition lock];
    [buffer addObject:[NSData dataWithBytes:srcbuf length:srclen]];
    [condition broadcast];
    [condition unlock];

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


-(NSStreamStatus)streamStatus {
    NSStreamStatus result;
    [condition lock];
    if (closed)
        result = NSStreamStatusClosed;
    else if (eof)
        result = NSStreamStatusAtEnd;
    else
        result = NSStreamStatusOpen;
    [condition unlock];
    return result;
}


-(void)closeOutput {
    [condition lock];
    eof = true;
    [condition broadcast];
    [condition unlock];
}


-(void)closeInput {
    [condition lock];
    closed = true;
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
    return [streamPair streamStatus];
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
    return [streamPair write:buffer maxLength:len];
}


-(BOOL)hasSpaceAvailable {
    return true;
}


-(NSStreamStatus)streamStatus {
    return [streamPair streamStatus];
}


-(NSError *)streamError {
    return nil;
}


-(void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {
}


-(void)removeFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {
}


@end
