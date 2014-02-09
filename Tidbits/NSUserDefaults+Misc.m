//
//  NSUserDefaults+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 1/28/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoggingMacros.h"

#import "NSUserDefaults+Misc.h"


@implementation NSUserDefaults (Misc)


+(void)tb_reloadFromMainBundle {
    NSString* plistName = [NSString stringWithFormat:@"%@.plist", [[NSBundle mainBundle] bundleIdentifier]];

    NSArray *libraryDirs = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if (libraryDirs.count == 0) {
        NSLog(@"Failed to find Library directory!  This is a very ill phone!");
        return;
    }
    NSString *libraryDir = libraryDirs[0];
    NSString* preferencesDir = [libraryDir stringByAppendingPathComponent:@"Preferences"];
    NSString* defaultsPath = [preferencesDir stringByAppendingPathComponent:plistName];
    NSDictionary* plistContents = [NSDictionary dictionaryWithContentsOfFile:defaultsPath];

    // Don't log the settings in production builds, for privacy reasons.
    NSString* loggablePlistContents =
#if DEBUG
    [plistContents description];
#else
    @"<redacted>";
#endif
    NSLog(@"Reloading %@ as defaults from %@", loggablePlistContents, defaultsPath);

    NSUserDefaults* defaults = [NSUserDefaults tb_standardUserDefaults];
    [defaults registerDefaults:plistContents];
    [defaults tb_synchronize];
}


static bool we_have_initialized = false;
+(NSUserDefaults *)tb_standardUserDefaults {
    UIApplication* app = [UIApplication sharedApplication];  // app is nil if we're running unit tests.
                                                             // Assume isProtectedDataAvailable=true in that case.
    if (app == nil || [app isProtectedDataAvailable] || we_have_initialized) {
        we_have_initialized = true;
        return [NSUserDefaults standardUserDefaults];
    }
    else {
        DLog(@"Warning: refusing to get NSUserDefaults because isProtectedDataAvailable = false and we haven't initialized yet.");
        return nil;
    }
}


-(BOOL)tb_synchronize {
    DLog(@"");
    if ([[UIApplication sharedApplication] isProtectedDataAvailable])
        return [self synchronize];
    else {
        DLog(@"Refusing to synchronize NSUserDefaults because isProtectedDataAvailable = false");
        return NO;
    }
}


@end
