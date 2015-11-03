//
//  Enumerate.h
//  Tidbits
//
//  Created by Ewan Mellor on 2/14/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/NSEnumerator.h>
#import <Foundation/NSObject.h>

#import "StandardBlocks.h"


@interface Enumerate : NSObject

/**
 * Call the given block with pairs taken from a1 and a2 in sequence.
 *
 * If one enumeration is shorter than the other, then the iteration will only run as long as the shorter one.
 * The remaining items in the longer one will be ignored.
 */
+(void)pairwiseOver:(id<NSFastEnumeration>)e1 and:(id<NSFastEnumeration>)e2 usingBlock:(IdIdBlock)block;

/**
 * The same as [Enumerate pairwiseOver:and:usingBlock:] except that the block may return a result and may abort the loop.
 *
 * @param block Receives (id obj1, id obj2, id* result, bool* done).  May set *result at any time; that will be returned
 * as the result of this call.  May set *done at any time -- that will terminate the loop with this iteration.
 * @return *result at the end of the last iteration of the loop, or nil if it was never set.
 */
+(id)pairwiseOver:(id<NSFastEnumeration>)e1 and:(id<NSFastEnumeration>)e2 usingBlockWithResult:(IdIdIdPtrBoolPtrBlock)block;

@end
