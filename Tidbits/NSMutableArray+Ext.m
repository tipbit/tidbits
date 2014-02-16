//
//  NSMutableArray+Ext.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/7/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

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


@end
