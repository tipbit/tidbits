//
//  NSMutableDictionary+Misc.m
//  TBClientLib
//
//  Created by Ewan Mellor on 5/2/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSMutableDictionary+Misc.h"

@implementation NSMutableDictionary (Misc)

-(void) addIfSet:(id)value forKey:(id<NSCopying>)key {
    if (value != nil)
        [self setObject:value forKey:key];
}

-(void) addIfSetIn:(NSDictionary*)source forKey:(id<NSCopying>)key {
    [self addIfSet:source[key] forKey:key];
}

-(void) addKeyIfSet:(id<NSCopying>)key value:(id)value {
    if (value != nil)
        [self setObject:value forKey:key];
}

-(void)mergeLeft:(NSDictionary *)dict {
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        self[key] = obj;
    }];
}

@end
