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
    return [self synchronize];
}


@end
