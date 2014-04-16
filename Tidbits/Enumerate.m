//
//  Enumerate.m
//  Tidbits
//
//  Created by Ewan Mellor on 2/14/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "Enumerate.h"


@implementation Enumerate


+(void)pairwiseOver:(id<NSFastEnumeration>)e1 and:(id<NSFastEnumeration>)e2 usingBlock:(IdIdBlock)block {
    [Enumerate pairwiseOver:e1 and:e2 usingBlockWithResult:^(id obj1, id obj2, __autoreleasing id *result, bool *done) {
        block(obj1, obj2);
    }];
}


+(id)pairwiseOver:(id<NSFastEnumeration>)e1 and:(id<NSFastEnumeration>)e2 usingBlockWithResult:(IdIdIdPtrBoolPtrBlock)block {
    const int bufsize = 16;
    __unsafe_unretained id buf1[bufsize];
    __unsafe_unretained id buf2[bufsize];
    NSUInteger avail1 = 0;
    NSUInteger avail2 = 0;
    NSUInteger consumed1 = 0;
    NSUInteger consumed2 = 0;
    NSFastEnumerationState state1 = {};
    NSFastEnumerationState state2 = {};
    id result = nil;
    bool done = false;

    while (true) {
        if (consumed1 == avail1) {
            consumed1 = 0;
            avail1 = [e1 countByEnumeratingWithState:&state1 objects:buf1 count:bufsize];
            if (avail1 == 0) {
                return result;
            }
        }
        if (consumed2 == avail2) {
            consumed2 = 0;
            avail2 = [e2 countByEnumeratingWithState:&state2 objects:buf2 count:bufsize];
            if (avail2 == 0) {
                return result;
            }
        }

        id obj1 = state1.itemsPtr[consumed1];
        id obj2 = state2.itemsPtr[consumed2];
        block(obj1, obj2, &result, &done);

        if (done) {
            return result;
        }

        consumed1++;
        consumed2++;
    }
}


@end
