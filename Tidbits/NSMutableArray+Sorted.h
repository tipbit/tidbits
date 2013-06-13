//
//  NSMutableArray+Sorted.h
//  Tipbit
//
//  Created by Ewan Mellor on 5/29/13.
//  Copyright (c) 2013 Tipbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Sorted)

/*!
 @abstract Find the index of the given obj, assuming that this list is already sorted with the given comparator.
 @discussion Returns NSNotFound if obj is not in this list.
 */
-(NSUInteger) indexOfObjectSorted:(id)obj usingComparator:(NSComparator)comparator;

/*!
 @abstract Insert obj at the position indicated by insertionIndexSorted.
 */
-(void) insertSorted:(id)obj usingComparator:(NSComparator)comparator;

/*!
 @abstract Find the correct position in this list to insert the given obj, using the given NSComparator, assuming that the list is already sorted.
 */
-(NSUInteger) insertionIndexSorted:(id)obj usingComparator:(NSComparator)comparator;

@end
