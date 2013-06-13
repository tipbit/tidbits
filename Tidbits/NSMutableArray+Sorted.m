//
//  NSMutableArray+Sorted.m
//  Tipbit
//
//  Created by Ewan Mellor on 5/29/13.
//  Copyright (c) 2013 Tipbit. All rights reserved.
//

#import "NSMutableArray+Sorted.h"

@implementation NSMutableArray (Sorted)

-(NSUInteger) indexOfObjectSorted:(id)obj usingComparator:(NSComparator)comparator {
    NSParameterAssert(comparator);

    return [self indexOfObject:obj inSortedRange:(NSRange){0, self.count} options:0 usingComparator:comparator];
}


-(void) insertSorted:(id)obj usingComparator:(NSComparator)comparator {
    NSUInteger idx = [self insertionIndexSorted:obj usingComparator:comparator];
    [self insertObject:obj atIndex:idx];
}


-(NSUInteger) insertionIndexSorted:(id)obj usingComparator:(NSComparator)comparator {
    NSParameterAssert(comparator);

    return [self indexOfObject:obj inSortedRange:(NSRange){0, self.count} options:NSBinarySearchingLastEqual | NSBinarySearchingInsertionIndex usingComparator:comparator];
}


@end
