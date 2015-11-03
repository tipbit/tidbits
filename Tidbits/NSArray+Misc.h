//
//  NSArray+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 10/3/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSEnumerator.h>
#import <Foundation/NSObjCRuntime.h>
#import <Foundation/NSString.h>

#import "StandardBlocks.h"


@interface NSArray (Misc)

+(instancetype)arrayWithEnumeration:(id<NSFastEnumeration>)objects;
+(instancetype)arrayWithEnumeration:(id<NSFastEnumeration>)objects mapper:(id_to_id_t)mapper;

-(NSArray *)arrayByRemovingObjectsInArray:(NSArray *)otherArray;

-(NSDictionary*)dictAtIndex:(NSUInteger)index;

-(id)objectAtIndex:(NSUInteger)index withDefault:(id)def;

/**
 * @return The first object in this array that matches the given predicate.  nil if nothing matches.
 */
-(id)objectPassingTest:(predicate_t)predicate __attribute__((nonnull));

/**
 * @return YES if at least one object in this array matches the given predicate.  NO otherwise.
 */
-(BOOL)containsObjectPassingTest:(predicate_t)predicate __attribute__((nonnull));

-(NSArray*)componentsJoinedByString:(NSString*)separator inBatches:(NSUInteger)batchSize;

-(NSArray*)filteredArrayUsingBlock:(predicate_t)predicate;

-(NSString *)toJSON;

@end
