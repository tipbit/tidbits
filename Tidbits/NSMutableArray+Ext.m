//
//  NSMutableArray+Ext.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/7/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSMutableArray+Ext.h"


@implementation NSMutableArray (Ext)


-(instancetype)initWithEnumeration:(id<NSFastEnumeration>)objects {
    self = [self init];
    if (self) {
        for (id obj in objects)
            [self addObject:obj];
    }
    return self;
}


-(instancetype)initWithEnumeration:(id<NSFastEnumeration>)objects mapper:(id_to_id_t)mapper {
    self = [self init];
    if (self) {
        for (id obj in objects) {
            id new_obj = mapper(obj);
            if (new_obj != nil) {
                [self addObject:new_obj];
            }
        }
    }
    return self;
}


-(void)addObjectsFromValuesOfDictionary:(NSDictionary *)dict {
    for (id k in dict) {
        [self addObject:dict[k]];
    }
}


-(void)filterUsingBlock:(predicate_t)predicate {
    [self filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return predicate(evaluatedObject);
    }]];
}


-(void)removeDuplicates {
    NSMutableIndexSet* to_remove = [NSMutableIndexSet indexSet];
    NSMutableSet* set = [NSMutableSet set];
    for (NSUInteger idx = 0; idx < self.count; idx++) {
        id obj = self[idx];
        if ([set containsObject:obj]) {
            [to_remove addIndex:idx];
        }
        else {
            [set addObject:obj];
        }
    }
    if (to_remove.count > 0)
        [self removeObjectsAtIndexes:to_remove];
}


-(void)shuffle {
    // Same as http://en.wikipedia.org/wiki/Fisher–Yates_shuffle,
    // but with i adjusted up by 1 to avoid wrap-around if self.count == 0.
    for (NSUInteger i = self.count; i >= 2; i--) {
        NSUInteger iminus1 = i - 1;
        NSUInteger j = arc4random_uniform((unsigned)iminus1);
        [self exchangeObjectAtIndex:(iminus1) withObjectAtIndex:j];
    }
}


@end
