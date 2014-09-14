//
//  NSMutableIndexSet+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 9/14/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSMutableIndexSet+Misc.h"


@implementation NSMutableIndexSet (Misc)


-(NSMutableIndexSet *)removeFirstN:(NSUInteger)n {
    NSMutableIndexSet * result = [NSMutableIndexSet indexSet];
    __block NSUInteger i = 0;
    [self enumerateRangesUsingBlock:^(NSRange range, BOOL *stop) {
        if (i + range.length <= n) {
            // We want this whole range.
            [result addIndexesInRange:range];
            i += range.length;
        }
        else {
            // We only want part of this range, so add the final indexes and then we're done.
            NSUInteger subrangeLen = n - i;
            [result addIndexesInRange:NSMakeRange(range.location, subrangeLen)];
            *stop = YES;
        }
    }];

    if (result.lastIndex != NSNotFound) {
        [self removeIndexesInRange:NSMakeRange(0, result.lastIndex + 1)];
    }
    return result;
}


@end
