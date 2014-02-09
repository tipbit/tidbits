//
//  NSUserDefaults+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 1/28/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Misc)

/**
 * Load the plist that contains the main settings, and use registerDefaults to put those settings into [NSUserDefaults standardUserDefaults].
 *
 * This can be used to load settings that didn't get loaded initially because the screen was locked.
 */
+(void)tb_reloadFromMainBundle;

/**
 * A wrapper to standardUserDefaults, except it won't load the settings if [UIApplication isProtectedDataAvailable] is false.
 *
 * This means that we won't load blank settings when the screen is locked.
 */
+(NSUserDefaults *)tb_standardUserDefaults;

/**
 * Equivalent to [self synchronize].
 *
 * This exists so that we have an intercept point for debugging.
 */
-(BOOL)tb_synchronize;

@end
