//
//  InlineTiming.h
//  Tidbits
//
//  Created by Ewan Mellor on 10/6/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#if DEBUG

#define InlineTimingMark                                                                 \
    assert(INLINE_TIMING_INDEX < 32);                                                    \
    INLINE_TIMING_TIMES[INLINE_TIMING_INDEX] = [NSDate timeIntervalSinceReferenceDate];  \
    INLINE_TIMING_LINES[INLINE_TIMING_INDEX] = __LINE__;                                 \
    INLINE_TIMING_INDEX++

#define InlineTimingStart                                                                \
    NSTimeInterval INLINE_TIMING_TIMES[32];                                              \
    NSUInteger INLINE_TIMING_LINES[32];                                                  \
    NSUInteger INLINE_TIMING_INDEX = 0;                                                  \
    InlineTimingMark

#define InlineTimingEnd                                                                  \
    InlineTimingMark;                                                                    \
    [InlineTiming log:__PRETTY_FUNCTION__ line:__LINE__                                  \
                  times:INLINE_TIMING_TIMES lines:INLINE_TIMING_LINES                    \
                  count:INLINE_TIMING_INDEX]

#else

#define InlineTimingMark
#define InlineTimingStart
#define InlineTimingEnd

#endif


#if DEBUG

@interface InlineTiming : NSObject

+(void)log:(const char*)func line:(NSUInteger)line times:(NSTimeInterval[])times lines:(NSUInteger[])lines count:(NSUInteger)count;

@end

#endif
