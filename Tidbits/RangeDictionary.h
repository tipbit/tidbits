//
//  RangeDictionary.h
//  Tidbits
//
//  Created by Ewan Mellor on 8/4/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 * A RangeDictionary holds key-value mappings like a normal NSDictionary, but the
 * keys are ranged values rather than single values.
 *
 * After an insert of [A..B] -> V, a lookup of any value between A and B will
 * return V.
 *
 * An insert that completely overlaps the range of a previous one will delete that
 * previous entry.
 *
 * An insert in the middle of the range of a previous one will split that previous
 * entry, resulting in three ranged entries.
 *
 * This class makes no attempt to be thread-safe, so if you need that then you
 * will need to handle that externally.
 *
 * Keys and values are all retained strongly.
 */
@interface RangeDictionary : NSObject

/**
 * @param comparator Used to sort the keys for all operations on this RangeDictionary.
 */
-(instancetype)initWithComparator:(NSComparator)comparator;

-(nullable id)objectForKey:(id)key;
-(nullable id)objectForKeyedSubscript:(id)key;

/**
 * from and to must be strictly in ascending order.  An empty range or an inverted
 * range will cause an assert.
 */
-(void)setObject:(id)obj from:(id<NSCopying>)from to:(id<NSCopying>)to;

// Unimplemented.
//-(void)removeObjectsFrom:(id<NSCopying>)from to:(id<NSCopying>)to;

-(void)removeAllObjects;

@end


NS_ASSUME_NONNULL_END
