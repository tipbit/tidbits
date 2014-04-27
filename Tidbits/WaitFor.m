//
//  WaitFor.m
//  Tidbits
//
//  Created by Ewan Mellor on 4/27/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "WaitFor.h"


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
        if (block && block()) {
            return true;
        }
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
