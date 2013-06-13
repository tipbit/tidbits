//
//  NSUserDefaults+Default.m
//  TBClientLib
//
//  Created by Ewan Mellor on 5/16/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSUserDefaults+Default.h"

@implementation NSUserDefaults (Default)

-(NSString*)stringForKey:(NSString *)defaultName defaultValue:(NSString*)def {
    NSString* val = [self stringForKey:defaultName];
    return val == nil ? def : val;
}

@end
