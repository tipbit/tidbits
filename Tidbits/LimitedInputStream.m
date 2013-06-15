//
//  LimitedInputStream.m
//  Tidbits
//
//  Created by Ewan Mellor on 6/15/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "LimitedInputStream.h"

@implementation LimitedInputStream

-(id)initWithStream:(NSInputStream *)stream andLimit:(NSUInteger)limit {
    self = [super init];
    if (self) {
        self.underStream = stream;
        self.bytesLimit = limit;
    }
    return self;
}


-(NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len {
    NSUInteger cappedLen = self.bytesLimit - self.bytesRead;
    if (cappedLen == 0)
        return 0;

    NSInteger result = [self.underStream read:buffer maxLength:MIN(cappedLen, len)];
    if (result >= 0)
        self.bytesRead += result;
    return result;
}


-(BOOL)getBuffer:(uint8_t **)buffer length:(NSUInteger *)len {
    return NO;
}


-(BOOL)hasBytesAvailable {
    return self.bytesRead == self.bytesLimit ? NO : [self.underStream hasBytesAvailable];
}


-(void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {
    [self.underStream scheduleInRunLoop:aRunLoop forMode:mode];
}


-(NSError *)streamError {
    return self.underStream.streamError;
}


-(NSStreamStatus)streamStatus {
    NSStreamStatus status = [self.underStream streamStatus];
    switch (status) {
        case NSStreamStatusNotOpen:
        case NSStreamStatusOpening:
        case NSStreamStatusReading:
        case NSStreamStatusWriting:
        case NSStreamStatusAtEnd:
        case NSStreamStatusClosed:
        case NSStreamStatusError:
            return status;

        case NSStreamStatusOpen:
            return self.bytesRead == self.bytesLimit ? NSStreamStatusAtEnd : NSStreamStatusOpen;
    }
}


@end
