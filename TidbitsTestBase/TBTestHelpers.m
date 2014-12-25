//
//  TBTestHelpers.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>

#import "TBTestHelpers.h"


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


void comparePerformanceAndLogResult(VoidBlock blockA, VoidBlock blockB) {
    NSTimeInterval delta;
    NSTimeInterval total;

    comparePerformance(blockA, blockB, &delta, &total);

    NSTimeInterval percentage = 100.0 * delta / total;
    if (delta > 0.0) {
        if (percentage < 1.0) {
            NSLog(@"No significant difference (B is faster by %f / %f = %.2f%%)", delta, total, percentage);
        }
        else {
            NSLog(@"B is faster than A by %f / %f = %.2f%%", delta, total, percentage);
        }
    }
    else {
        delta = -delta;
        percentage = -percentage;
        if (percentage < 1.0) {
            NSLog(@"No significant difference (A is faster by %f / %f = %.2f%%)", delta, total, percentage);
        }
        else {
            NSLog(@"A is faster than B by %f / %f = %.2f%%", delta, total, percentage);
        }
    }
}


void comparePerformance(VoidBlock blockA, VoidBlock blockB, NSTimeInterval * outDelta, NSTimeInterval * outTotal) {
    assert(outDelta != NULL);
    assert(outTotal != NULL);

    NSTimeInterval delta = 0;
    NSTimeInterval total = 0;
    int repetitions = 0;

    // We do two repetitions inside the block -- once with A before B and once the other way around.
    // This shouldn't make any difference, but you never know.
    while (total < 10.0 || repetitions < 10) {
        NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
        blockA();
        NSTimeInterval mid = [NSDate timeIntervalSinceReferenceDate];
        blockB();
        NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
        delta += mid;
        delta -= start;
        delta -= end;
        delta += mid;
        total += end;
        total -= start;
        start = [NSDate timeIntervalSinceReferenceDate];
        blockB();
        mid = [NSDate timeIntervalSinceReferenceDate];
        blockA();
        end = [NSDate timeIntervalSinceReferenceDate];
        delta -= mid;
        delta += start;
        delta += end;
        delta -= mid;
        total += end;
        total -= start;
        repetitions += 2;
    }

    *outDelta = delta;
    *outTotal = total;
}
