//
//  NSMutableArray+Ext.h
//  Tidbits
//
//  Created by Ewan Mellor on 12/7/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Ext)

-(instancetype)initWithEnumeration:(id<NSFastEnumeration>)objects;

/**
 * Remove any duplicates from this array, using the same equality test as [NSSet containsObject].  The order of the remaining objects is preserved (i.e.
 * the first occurrence of each object is kept in this array at its original position).
 */
-(void)removeDuplicates;

@end
