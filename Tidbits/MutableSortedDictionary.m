//
//  MutableSortedDictionary.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/2/15.
//  Copyright © 2015 Tipbit, Inc. All rights reserved.
//

#import "NSMutableArray+Sorted.h"

#import "MutableSortedDictionary.h"

NS_ASSUME_NONNULL_BEGIN


@interface MutableSortedDictionary<__covariant KeyType, __covariant ObjectType> ()

@property (nonatomic, copy, readonly) NSComparator comparator;
@property (nonatomic, readonly) NSMutableArray<KeyType> * keyArray;
@property (nonatomic, readonly) NSMutableDictionary<KeyType, ObjectType> * dict;

@end


@implementation MutableSortedDictionary


static NSComparator defaultComparator;

+(void)initialize {
    defaultComparator = ^NSComparisonResult(id obj1, id obj2) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-selector-match"
        return [obj1 compare:obj2];
#pragma clang diagnostic pop
    };
}


-(instancetype)initWithComparator:(nullable NSComparator)comparator {
    self = [super init];
    if (self) {
        _comparator = (comparator ?: defaultComparator);
        _keyArray = [NSMutableArray array];
        _dict = [NSMutableDictionary dictionary];
    }
    return self;
}


-(NSUInteger)count {
    return self.keyArray.count;
}


-(id)objectAtIndex:(NSUInteger)index {
    return self.dict[self.keyArray[index]];
}

-(id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.dict[self.keyArray[idx]];
}


-(nullable id)objectForKey:(id)aKey {
    return self.dict[aKey];
}

-(nullable id)objectForKeyedSubscript:(id)key {
    return self.dict[key];
}


-(void)setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    [self setObject:anObject forKeyedSubscript:aKey];
}

-(void)setObject:(nullable id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (obj == nil) {
        [self.dict removeObjectForKey:key];
        [self.keyArray removeObject:key];
    }
    else {
        self.dict[key] = obj;
        if (![self.keyArray containsObject:key]) {
            [self.keyArray insertSorted:key usingComparator:self.comparator];
        }
    }
}


-(void)removeAllObjects {
    [self.dict removeAllObjects];
    [self.keyArray removeAllObjects];
}


-(void)removeLastObject {
    [self removeObjectAtIndex:self.count - 1];
}


-(void)removeObjectAtIndex:(NSUInteger)index {
    id key = self.keyArray[index];
    [self.dict removeObjectForKey:key];
    [self.keyArray removeObjectAtIndex:index];
}


-(void)removeObjectForKey:(id)aKey {
    [self.dict removeObjectForKey:aKey];
    [self.keyArray removeObject:aKey];
}


-(void)removeObjectsForKeys:(NSArray *)keyArray {
    [self.dict removeObjectsForKeys:keyArray];
    [self.keyArray removeObjectsInArray:keyArray];
}


@end


NS_ASSUME_NONNULL_END
