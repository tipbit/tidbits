//
//  Enumerate.h
//  Tidbits
//
//  Created by Ewan Mellor on 2/14/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StandardBlocks.h"


@interface Enumerate : NSObject

/**
 * Call the given block with pairs taken from a1 and a2 in sequence.
 *
 * If one enumeration is shorter than the other, then the iteration will only run as long as the shorter one.
 * The remaining items in the longer one will be ignored.
 */
+(void)pairwiseOver:(id<NSFastEnumeration>)e1 and:(id<NSFastEnumeration>)e2 usingBlock:(IdIdBlock)block;

@end
