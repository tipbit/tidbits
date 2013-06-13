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
    return result ? [result boolValue] : def;
}


-(id) objectForKey:(id)key withDefault:(id)def {
    id result = [self objectForKey:key];
    return result ? result : def;
}


-(NSUInteger)uintForKey:(id)key withDefault:(NSUInteger)def {
    id result = [self objectForKey:key];
    return result ? [result unsignedIntegerValue] : def;
}


@end
