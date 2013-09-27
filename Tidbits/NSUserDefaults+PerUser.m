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

+(NSString*)PUKey:(NSString*) key {
    return [self PUKey:key user:[[NSUserDefaults standardUserDefaults] stringForKey:@"USER"]];
}

+(NSString*)PUKey:(NSString*) key user:(NSString*) TBUser {
    if (key != nil && TBUser != nil)
        return [NSString stringWithFormat:@"%@:%@", TBUser, key];
    else {
        NSAssert(false, @"PUKey got unexpected key or user");
        return nil;
    }
}

+(BOOL)getPUBool:(NSString*)key {
    return[[NSUserDefaults standardUserDefaults] boolForKey:key defaultValue:YES];
}

+(void)setPUBool:(BOOL)value forKey:(NSString*)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}

+(NSString*)getPUString:(NSString*)key {
    return[[NSUserDefaults standardUserDefaults] stringForKey:key];
}

+(void)setPUString:(NSString*)value forKey:(NSString*)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

@end
