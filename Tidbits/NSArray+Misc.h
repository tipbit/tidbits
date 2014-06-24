//
//  NSArray+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 10/3/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StandardBlocks.h"


@interface NSArray (Misc)

+(instancetype)arrayWithEnumeration:(id<NSFastEnumeration>)objects;
+(instancetype)arrayWithEnumeration:(id<NSFastEnumeration>)objects mapper:(id_to_id_t)mapper;

-(NSDictionary*)dictAtIndex:(NSUInteger)index;

-(id)objectAtIndex:(NSUInteger)index withDefault:(id)def;

/**
 * @return The first object in this array that matches the given predicate.  nil if nothing matches.
 */
-(id)objectPassingTest:(predicate_t)predicate __attribute__((nonnull));

-(NSArray*)componentsJoinedByString:(NSString*)separator inBatches:(NSUInteger)batchSize;

-(NSArray*)filteredArrayUsingBlock:(predicate_t)predicate;

@end
