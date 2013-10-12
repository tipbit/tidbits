//
//  NSUserDefaults+PerUser.m
//  TBClientLib
//
//  Created by Nat Ballou on 9/26/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSUserDefaults+Default.h"
#import "NSUserDefaults+PerUser.h"

@implementation NSUserDefaults (PerUser)

-(NSString*)PUKey:(NSString*) key {
    return [self PUKey:key user:[self stringForKey:@"USER"]];
}

-(NSString*)PUKey:(NSString*) key user:(NSString*) TBUser {
    if (key != nil && TBUser != nil)
        return [NSString stringWithFormat:@"%@:%@", TBUser, key];
    else {
        NSAssert(false, @"PUKey got unexpected key/user pair: %@", key);
        return key;
    }
}

-(BOOL)boolForPUKey:(NSString*)key {
    return [self boolForKey:[self PUKey:key]];
}

-(BOOL)boolForPUKey:(NSString*)key defaultValue:(BOOL)defValue {
    return [self boolForKey:[self PUKey:key] defaultValue:defValue];
}

-(void)setBoolForPUKey:(BOOL)value forKey:(NSString*)key {
    [self setBool:value forKey:[self PUKey:key]];
}

-(NSString*)stringForPUKey:(NSString*)key {
    return [self objectForKey:[self PUKey:key]];
}

-(NSString*)stringForPUKey:(NSString*)key user:(NSString*)user {
    return [self objectForKey:[self PUKey:key user:user]];
}

-(NSString*)stringForPUKey:(NSString*)key defaultValue:(NSString*)defValue {
    return [self stringForKey:[self PUKey:key] defaultValue:defValue];
}

-(void)setStringForPUKey:(NSString*)value forKey:(NSString*)key {
    [self setObject:value forKey:[self PUKey:key]];
}

-(id)objectForPUKey:(NSString*)key {
    return [self objectForKey:[self PUKey:key]];
}

-(void)setObjectForPUKey:(NSObject*)value forKey:(NSString*)key {
    [self setObject:value forKey:[self PUKey:key]];
}

-(void)removeObjectForPUKey:(NSString*)key {
    [self removeObjectForKey:[self PUKey:key]];
}

@end
