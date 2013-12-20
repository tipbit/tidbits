//
//  TBTestHelpers.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>

#import "TBTestHelpers.h"


#define DEFAULT_TIMEOUT 10.0


bool WaitFor(bool (^block)(void)) {
    return WaitForTimeout(DEFAULT_TIMEOUT, block);
}


bool WaitForMainThread() {
    return WaitForTimeout(0.0, NULL);
}


bool WaitForTimeout(NSTimeInterval timeout, bool (^block)(void)) {
    NSTimeInterval start = [[NSProcessInfo processInfo] systemUptime];
    do {
        if (block && block())
            return true;
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
    } while ([[NSProcessInfo processInfo] systemUptime] - start <= timeout);
    return false;
}


bool WaitForTimeoutAsync(NSTimeInterval timeout, void (^block)(bool* done)) {
    __block bool done = false;
    block(&done);

    WaitForTimeout(timeout, ^bool{
        return done;
    });

    return done;
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
