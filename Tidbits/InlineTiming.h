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
  do {                                                                                   \
    assert(INLINE_TIMING_INDEX < INLINE_TIMING_MAX);                                     \
    INLINE_TIMING_TIMES[INLINE_TIMING_INDEX] = [NSDate timeIntervalSinceReferenceDate];  \
    INLINE_TIMING_LINES[INLINE_TIMING_INDEX] = __LINE__;                                 \
    INLINE_TIMING_INDEX++;                                                               \
  } while (false)

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


#define InlineTimingHeapPropertyDecl(__name) \
    @property (nonatomic, strong) InlineTiming* __name

#define InlineTimingHeapDeclStart(__name) \
    InlineTiming* __name = [[InlineTiming alloc] init:__LINE__]

#define InlineTimingHeapStart(__name) \
    __name = [[InlineTiming alloc] init:__LINE__]

#define InlineTimingHeapMark(__instance) \
    [__instance mark:__LINE__]

#define InlineTimingHeapEnd(__instance) \
    [__instance endWithBudget:0 func:__PRETTY_FUNCTION__ line:__LINE__]

#define InlineTimingHeapEndWithBudget(__instance, __budget) \
    [__instance endWithBudget:__budget func:__PRETTY_FUNCTION__ line:__LINE__]

#else

#define InlineTimingMark
#define InlineTimingStart
#define InlineTimingEndWithBudget(__budget)
#define InlineTimingEnd

#define InlineTimingHeapPropertyDecl(__name)
#define InlineTimingHeapDeclStart(__name)
#define InlineTimingHeapStart(__name)
#define InlineTimingHeapMark(__instance)
#define InlineTimingHeapEnd(__instance)
#define InlineTimingHeapEndWithBudget(__instance, __budget)

#endif


#if DEBUG

@interface InlineTiming : NSObject {
    NSTimeInterval times[INLINE_TIMING_MAX];
    NSUInteger lines[INLINE_TIMING_MAX];
    NSUInteger index;
}


-(id)init:(NSUInteger)line;
-(void)mark:(NSUInteger)line;
-(void)endWithBudget:(NSTimeInterval)budget func:(const char*)func line:(NSUInteger)line;

+(void)log:(const char*)func line:(NSUInteger)line times:(const NSTimeInterval[])times lines:(const NSUInteger[])lines count:(NSUInteger)count budget:(NSTimeInterval)budget;

@end

#endif
