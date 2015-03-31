//
//  NSNotificationCenter+MainThread.h
//  Tidbits
//
//  Created by Navi Singh on 3/30/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (MainThread)

- (void)postNotificationOnMainThread:(NSNotification *)note;
- (void)postOnMainThread:(NSString *)name;
- (void)postOnMainThread:(NSString *)name object:(id)obj;
- (void)postOnMainThread:(NSString *)name object:(id)obj userInfo:(NSDictionary *)userInfo;
- (void)postOnMainThread:(NSString *)name userInfo:(NSDictionary *)userInfo;

@end
