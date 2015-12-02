//
//  MutableSortedDictionary.h
//  Tidbits
//
//  Created by Ewan Mellor on 12/2/15.
//  Copyright © 2015 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface MutableSortedDictionary<__covariant KeyType, __covariant ObjectType> : NSMutableDictionary<KeyType, ObjectType>

/**
 * @param comparator May be NULL, in which case a default comparator will be used that
 * calls compare: on each of the objects.
 */
-(instancetype)initWithComparator:(nullable NSComparator)comparator;

-(ObjectType)objectAtIndex:(NSUInteger)index;
-(ObjectType)objectAtIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0);

-(void)removeLastObject;
-(void)removeObjectAtIndex:(NSUInteger)index;

@end


NS_ASSUME_NONNULL_END
