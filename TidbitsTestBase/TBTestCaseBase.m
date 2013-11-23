//
//  TBTestCaseBase.m
//  Tidbits
//
//  Created by Ewan Mellor on 10/9/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import "GTMCodeCoverageApp.h"

#import "TBTestCaseBase.h"


#define DEFAULT_TIMEOUT 10.0


bool WaitFor(bool (^block)(void)) {
    return WaitForTimeout(DEFAULT_TIMEOUT, block);
}


bool WaitForTimeout(NSTimeInterval timeout, bool (^block)(void)) {
    NSTimeInterval start = [[NSProcessInfo processInfo] systemUptime];
    do {
        if (block())
            return true;
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
    } while ([[NSProcessInfo processInfo] systemUptime] - start <= timeout);
    return false;
}


bool isReachable(NSString* hostname)
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
    SCNetworkReachabilityFlags flags;
    Boolean ok = SCNetworkReachabilityGetFlags(reachability, &flags);
    bool result;
    if (!ok)
        result = false;
    else
        result = (0 != (flags & kSCNetworkReachabilityFlagsReachable));
    CFRelease(reachability);
    return result;
}


@implementation TBTestCaseBase


-(void)tearDown {
    // When running under XCTest, libraries are in a different environment than applications.
    // With applications, we have XCInjectBundle set (pointing at the test bundle which has been injected)
    // and GTMCodeCoverageTests.stopObserving is called on exit.
    // With libraries, we have neither, so we need to call gtm_gcov_flush here instead.
    // This presumably slows things down slightly, since we're being called for the tearDown of every test
    // rather than once at the end.  The stats come out correct though.
    char* bundle = getenv("XCInjectBundle");
    if (!bundle)
        [[UIApplication sharedApplication] gtm_gcov_flush];
}


@end
