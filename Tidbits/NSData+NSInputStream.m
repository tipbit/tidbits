//
//  NSData+NSInputStream.m
//  Tidbits
//
//  Created by Ewan Mellor on 6/16/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSData+NSInputStream.h"

#define BUFSIZE 65536U

@implementation NSData (NSInputStream)

+(NSData *)dataWithContentsOfStream:(NSInputStream *)input initialCapacity:(NSUInteger)capacity {
    size_t bufsize = MIN(BUFSIZE, capacity);
    uint8_t* buf = malloc(bufsize);
    NSMutableData* result = [NSMutableData dataWithCapacity:capacity];
    while (true) {
        NSInteger n = [input read:buf maxLength:bufsize];
        if (n < 0) {
            result = nil;
            break;
        }
        else if (n == 0) {
            break;
        }
        else {
            [result appendBytes:buf length:n];
        }
    }

    free(buf);
    return result;
}


@end
