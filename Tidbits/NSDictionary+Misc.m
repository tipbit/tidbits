//
//  NSDictionary+Misc.m
//  TBClientLib
//
//  Created by Ewan Mellor on 5/30/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSDictionary+Misc.h"

@implementation NSDictionary (Misc)

-(bool)boolForKey:(id)key withDefault:(bool)def {
    id result = [self objectForKey:key];
    if (![result respondsToSelector:@selector(boolValue)]) {
        return def;
    }
    return result ? [result boolValue] : def;
}


-(double)doubleForKey:(id)key withDefault:(double)def {
    id result = [self objectForKey:key];
    return [result respondsToSelector:@selector(doubleValue)] ? [result doubleValue] : def;
}


-(id) objectForKey:(id)key withDefault:(id)def {
    id result = [self objectForKey:key];
    return result ? result : def;
}


-(NSInteger)intForKey:(id)key withDefault:(NSInteger)def {
    NSNumber* result = [self numberForKey:key];
    return result ? [result integerValue] : def;
}


-(NSUInteger)uintForKey:(id)key withDefault:(NSUInteger)def {
    NSNumber* result = [self numberForKey:key];
    return result ? [result unsignedIntegerValue] : def;
}


-(NSArray *)arrayForKey:(id)key {
    id result = self[key];
    return [result isKindOfClass:[NSArray class]] ? result : nil;
}


-(NSDictionary *)dictForKey:(id)key {
    id result = self[key];
    return [result isKindOfClass:[NSDictionary class]] ? result : nil;
}


-(NSNumber *)numberForKey:(id)key {
    id result = self[key];
    return [result isKindOfClass:[NSNumber class]] ? result : nil;
}


-(NSString *)stringForKey:(id)key {
    id result = self[key];
    return [result isKindOfClass:[NSString class]] ? result : nil;
}


-(id<NSCopying>)anyKey {
    for (id<NSCopying> key in self) {
        return key;
    }
    return nil;
}


-(id)anyValue {
    for (id<NSCopying> key in self) {
        return self[key];
    }
    return nil;
}


@end
