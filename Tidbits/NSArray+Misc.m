//
//  NSArray+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 10/3/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSMutableArray+Ext.h"

#import "NSArray+Misc.h"


@implementation NSArray (Misc)


+(instancetype)arrayWithEnumeration:(id<NSFastEnumeration>)objects {
    return [[NSMutableArray alloc] initWithEnumeration:objects];
}


+(instancetype)arrayWithEnumeration:(id<NSFastEnumeration>)objects mapper:(id_to_id_t)mapper {
    return [[NSMutableArray alloc] initWithEnumeration:objects mapper:mapper];
}


-(NSDictionary*)dictAtIndex:(NSUInteger)index {
    id result = [self objectAtIndex:index withDefault:nil];
    return [result isKindOfClass:[NSDictionary class]] ? result : nil;
}


-(id)objectAtIndex:(NSUInteger)index withDefault:(id)def {
    return index < self.count ? self[index] : def;
}


-(id)objectPassingTest:(predicate_t)predicate __attribute__((nonnull)) {
    NSParameterAssert(predicate);

    NSUInteger result_idx = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return predicate(obj);
    }];
    return result_idx == NSNotFound ? nil : self[result_idx];
}


-(NSArray *)componentsJoinedByString:(NSString *)separator inBatches:(NSUInteger)batchSize {
    NSMutableArray* result = [NSMutableArray array];
    NSUInteger i = 0;
    NSUInteger count = self.count;
    while (i < count) {
        NSUInteger remaining = count - i;
        NSUInteger thisBatch = remaining > batchSize ? batchSize : remaining;

        [result addObject:[[self subarrayWithRange:NSMakeRange(i, thisBatch)] componentsJoinedByString:separator]];

        i += thisBatch;
    }

    return result;
}


-(NSArray*)filteredArrayUsingBlock:(predicate_t)predicate {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return predicate(evaluatedObject);
    }]];
}


@end
