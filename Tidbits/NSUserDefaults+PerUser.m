//
//  NSUserDefaults+PerUser.m
//  TBClientLib
//
//  Created by Nat Ballou on 9/26/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSUserDefaults+Default.h"
#import "NSUserDefaults+Misc.h"
#import "NSUserDefaults+PerUser.h"

#define kTipbitUser @"USER"
#define kTipbitUserType @"USERTYPE"

@implementation NSUserDefaults (PerUser)

// Cache for Tipbit user.  Cleared on logout.
static NSString *cacheUser = nil;
static NSString *cacheUserType = nil;

-(NSString*)getTipbitUser {
    if (cacheUser == nil) {
        cacheUser = [self stringForKey:kTipbitUser];
    }
    
    return cacheUser;
}
-(NSString*)getTipbitUserType {
    if (cacheUserType == nil) {
        cacheUserType = [self stringForKey:kTipbitUserType];
    }
    
    return cacheUserType;
}

-(void)clearTipbitUserAndSynchronize {
    [self removeObjectForKey:kTipbitUser];
//    [self removeObjectForKey:kTipbitUserType];//we do not do this as we use this value for the signIn prompt with getLastTipbitSignoutUser
    [self tb_synchronize];
    cacheUser = nil;
//    cacheUserType = nil; //we do not do this as we use this value for the signIn prompt with getLastTipbitSignoutUser
}

-(NSString*)PUKey:(NSString*) key {
    return [self PUKey:key user:[self getTipbitUser]];
}

-(NSString*)PUKey:(NSString*) key user:(NSString*) TBUser {
    if (key != nil && TBUser != nil)
        return [NSString stringWithFormat:@"%@:%@", TBUser, key];
    else {
        NSAssert(false, @"PUKey got unexpected key/user pair: %@", key);
        return key;
    }
}

-(NSArray*)arrayForPUKey:(NSString*)key user:(NSString*)user {
    return [self arrayForKey:[self PUKey:key user:user]];
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
    return [self stringForKey:[self PUKey:key]];
}

-(NSString*)stringForPUKey:(NSString*)key user:(NSString*)user {
    return [self stringForKey:[self PUKey:key user:user]];
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
