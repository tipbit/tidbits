//
//  InlineTiming.m
//  Tidbits
//
//  Created by Ewan Mellor on 10/6/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "InlineTiming.h"


#if DEBUG

@implementation InlineTiming


-(id)init:(NSUInteger)line {
    self = [super init];
    if (self) {
        index = 0;
        [self mark:line];
    }
    return self;
}


-(void)mark:(NSUInteger)line {
    assert(index < INLINE_TIMING_MAX);
    times[index] = [NSDate timeIntervalSinceReferenceDate];
    lines[index] = line;
    index++;
}


-(void)endWithBudget:(NSTimeInterval)budget func:(const char*)func line:(NSUInteger)line {
    [self mark:line];
    [InlineTiming log:func line:line times:times lines:lines count:index budget:budget];
}


+(void)log:(const char*)func line:(NSUInteger)line times:(const NSTimeInterval[])times lines:(const NSUInteger[])lines count:(NSUInteger)count budget:(NSTimeInterval)budget {
    if (count <= 1)
        return;

    NSTimeInterval total_time = times[count - 1] - times[0];
    if (total_time < budget)
        return;

    NSTimeInterval max_delta = 0;
    NSUInteger max_line = 0;
    NSMutableString* str = [NSMutableString string];
    NSTimeInterval previous = times[0];
    for (int i = 1; i < count; i++) {
        NSTimeInterval time = times[i];
        NSTimeInterval delta = time - previous;
        [str appendFormat:@" %lf", delta];
        previous = time;
        if (delta > max_delta) {
            max_delta = delta;
            max_line = lines[i];
        }
    }
    NSLog(@"Timings for %s:%u:%@", func, line, str);
    NSLog(@"Timings for %s:%u: total time %lf", func, line, total_time);
    NSLog(@"Timings for %s:%u: max delta was %lf(%0.2lf%%) at line %u", func, line, max_delta, 100 * max_delta / total_time, max_line);
}

@end

#endif
