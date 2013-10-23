//
//  InlineTiming.h
//  Tidbits
//
//  Created by Ewan Mellor on 10/6/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#if DEBUG

#define INLINE_TIMING_MAX 32

#define InlineTimingMark                                                                 \
    assert(INLINE_TIMING_INDEX < INLINE_TIMING_MAX);                                     \
    INLINE_TIMING_TIMES[INLINE_TIMING_INDEX] = [NSDate timeIntervalSinceReferenceDate];  \
    INLINE_TIMING_LINES[INLINE_TIMING_INDEX] = __LINE__;                                 \
    INLINE_TIMING_INDEX++

#define InlineTimingStart                                                                \
    NSTimeInterval INLINE_TIMING_TIMES[INLINE_TIMING_MAX];                               \
    NSUInteger INLINE_TIMING_LINES[INLINE_TIMING_MAX];                                   \
    NSUInteger INLINE_TIMING_INDEX = 0;                                                  \
    InlineTimingMark

// InlineTimingEndWithBudget(b) will do nothing if the total elapsed time is less than b.
// Otherwise, it will log all the timings.
#define InlineTimingEndWithBudget(__budget)                                              \
    InlineTimingMark;                                                                    \
    [InlineTiming log:__PRETTY_FUNCTION__ line:__LINE__                                  \
                  times:INLINE_TIMING_TIMES lines:INLINE_TIMING_LINES                    \
                  count:INLINE_TIMING_INDEX budget:__budget]

// InlineTimingEnd is equivalent to InlineTimingEndWithBudget(0)
// In other words, it logs the timings no matter what.
#define InlineTimingEnd                                                                  \
    InlineTimingEndWithBudget(0)

#else

#define InlineTimingMark
#define InlineTimingStart
#define InlineTimingEndWithBudget(__budget)
#define InlineTimingEnd

#endif


#if DEBUG

@interface InlineTiming : NSObject

+(void)log:(const char*)func line:(NSUInteger)line times:(NSTimeInterval[])times lines:(NSUInteger[])lines count:(NSUInteger)count budget:(NSTimeInterval)budget;

@end

#endif
