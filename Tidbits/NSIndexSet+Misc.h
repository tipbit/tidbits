//
//  NSIndexSet+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 11/1/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexSet (Misc)

/**
 * @param array NSNumber array, where the numbers are treated as NSUIntegers.
 */
+(instancetype)indexSetWithIndexesInArray:(NSArray*)array;

/**
 * Create a new NSIndexPath array, with all the paths pointing to (section, row) pairs where the row numbers are as specified by this NSIndexSet.
 * c.f. NSIndexPath (UITableView).
 */
-(NSArray*)indexPathsInSection:(NSInteger)section;

/**
 * Create a new NSIndexPath array, with all the paths pointing to (section, row) pairs where the rows are 0 and the section numbers are as specified by this NSIndexSet.
 * c.f. NSIndexPath (UITableView).
 */
-(NSArray*)zeroRowIndexPathsForSections;

@end
