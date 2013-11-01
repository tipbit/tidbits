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
 * Create a new NSIndexPath array, with all the paths pointing to (section, row) pairs where the row numbers are as specified by this NSIndexSet.
 * c.f. NSIndexPath (UITableView).
 */
-(NSArray*)indexPathsInSection:(NSInteger)section;

@end
