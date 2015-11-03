//
//  NSMutableArray+Ext.h
//  Tidbits
//
//  Created by Ewan Mellor on 12/7/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSEnumerator.h>

#import "StandardBlocks.h"


@interface NSMutableArray (Ext)

-(instancetype)initWithEnumeration:(id<NSFastEnumeration>)objects;

/**
 * Initialize this NSMutableArray with the contents set to mapper(x) for each x in objects.
 *
 * mapper may return nil, in which case no entry is added to the result
 * (i.e. the result will be shorter than self).
 *
 * This is the same as NSArray.map in NSArray+Map, but generalized to any NSFastEnumeration.
 */
-(instancetype)initWithEnumeration:(id<NSFastEnumeration>)objects mapper:(id_to_id_t)mapper;

-(void)addObjectsFromValuesOfDictionary:(NSDictionary *)dict;

-(void)filterUsingBlock:(predicate_t)predicate;

/**
 * Remove any duplicates from this array, using the same equality test as [NSSet containsObject].  The order of the remaining objects is preserved (i.e.
 * the first occurrence of each object is kept in this array at its original position).
 */
-(void)removeDuplicates;

/**
 * In-place Fischer-Yates shuffle.
 */
-(void)shuffle;

@end
