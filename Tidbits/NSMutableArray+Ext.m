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


@end
