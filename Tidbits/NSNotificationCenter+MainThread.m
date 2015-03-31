//
//  NSNotificationCenter+MainThread.m
//  Tidbits
//
//  Created by Navi Singh on 3/30/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "NSNotificationCenter+MainThread.h"
#import "Dispatch.h"

@implementation NSNotificationCenter (MainThread)

- (void)postNotificationOnMainThread:(NSNotification *)note
{
    dispatch_async(dispatch_get_main_queue(),^{
        [NSNotificationCenter.defaultCenter postNotification:note];
    });
}

- (void)postOnMainThread:(NSString *)name
{
    [self postNotificationOnMainThread:[NSNotification notificationWithName:name object:nil]];
}

- (void)postOnMainThread:(NSString *)name object:(id)obj
{
    [self postNotificationOnMainThread:[NSNotification notificationWithName:name object:obj]];
}

- (void)postOnMainThread:(NSString *)name userInfo:(NSDictionary *)userInfo
{
    [self postNotificationOnMainThread:[NSNotification notificationWithName:name object:nil userInfo:userInfo]];
}

- (void)postOnMainThread:(NSString *)name object:(id)obj userInfo:(NSDictionary *)userInfo
{
    [self postNotificationOnMainThread:[NSNotification notificationWithName:name object:obj userInfo:userInfo]];
}

@end

