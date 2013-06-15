//
//  NSInputStream+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 6/15/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSInputStream+Misc.h"

@implementation NSInputStream (Misc)

-(NSInteger)readUint32:(uint32_t*)result {
    return readLen(self, 4);
}


static NSInteger readLen(NSInputStream* is, int len) {
    u_int8_t buf[len];
    int n = 0;
    while (true) {
        int i = [is read:(buf + n) maxLength:len - n];
        if (i <= 0)
            return i;

        n += i;

        if (n == len)
            return n;
    }
}


@end
