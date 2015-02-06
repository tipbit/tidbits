//
//  Dispatch.m
//  TBClientLib
//
//  Created by Ewan Mellor on 5/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/NSException.h>

#import "Dispatch.h"
#import "LoggingMacros.h"


#define DURATION_WARNING_THRESHOLD 0.1


#if DURATION_WARNING_ENABLED

#undef dispatchSyncMainThread
#undef dispatchAsyncMainThread
#undef dispatchAsyncMainThreadWithDelay
#undef dispatchSyncMainThreadWithResult

#define DURATION_WARNING_GET_SYMBOLS \
    NSArray* symbols = [NSThread callStackSymbols]

#define DURATION_WARNING_START \
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate]

#define DURATION_WARNING_END \
    do { \
        NSTimeInterval duration = [NSDate timeIntervalSinceReferenceDate] - start; \
        if (duration > DURATION_WARNING_THRESHOLD) \
            durationWarning(func, line, duration, symbols); \
    } while (false)

// This is a separate function from the macro above so that you can stick a breakpoint here.
static void durationWarning(const char* func, int line, NSTimeInterval duration, NSArray* symbols) {
    DLog(@"Operation on main thread took %0.6lf secs.  Call-site: %s:%d.  Call-stack: %@", duration, func, line, symbols);
}

#else

#define DURATION_WARNING_GET_SYMBOLS
#define DURATION_WARNING_START
#define DURATION_WARNING_END

#endif


void dispatchSyncMainThread(DURATION_WARNING_EXTRA_ARGS VoidBlock block) {
    DURATION_WARNING_GET_SYMBOLS;

    if ([NSThread isMainThread]) {
        DURATION_WARNING_START;
        block();
        DURATION_WARNING_END;
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            DURATION_WARNING_START;
            block();
            DURATION_WARNING_END;
        });
    }
}


id dispatchSyncMainThreadWithResult(DURATION_WARNING_EXTRA_ARGS GetIdBlock block) {
    DURATION_WARNING_GET_SYMBOLS;

    if ([NSThread isMainThread]) {
        DURATION_WARNING_START;
        return block();
        DURATION_WARNING_END;
    }
    else {
        __block id result = nil;
        dispatch_sync(dispatch_get_main_queue(), ^{
            DURATION_WARNING_START;
            result = block();
            DURATION_WARNING_END;
        });
        return result;
    }
}


void dispatchAsyncMainThread(DURATION_WARNING_EXTRA_ARGS VoidBlock block) {
    DURATION_WARNING_GET_SYMBOLS;

    dispatch_async(dispatch_get_main_queue(), ^{
        DURATION_WARNING_START;
        block();
        DURATION_WARNING_END;
    });
}

#define DISPATCH_MSEC_FROM_NOW(__ms) (dispatch_time(DISPATCH_TIME_NOW, ((int64_t)__ms) * NSEC_PER_MSEC))

void dispatchAsyncMainThreadWithDelay(DURATION_WARNING_EXTRA_ARGS int delay_msec, VoidBlock block) {
    DURATION_WARNING_GET_SYMBOLS;

    dispatch_after(DISPATCH_MSEC_FROM_NOW(delay_msec), dispatch_get_main_queue(), ^{
        DURATION_WARNING_START;
        block();
        DURATION_WARNING_END;
    });
}

void dispatchAsyncBackgroundThreadWithDelay(int delay_msec, dispatch_queue_priority_t prio, VoidBlock block) {

    dispatch_after(DISPATCH_MSEC_FROM_NOW(delay_msec), dispatch_get_global_queue(prio, 0), ^{
        block();
    });
}

void dispatchAsyncBackgroundThread(dispatch_queue_priority_t prio, VoidBlock block) {
    dispatch_async(dispatch_get_global_queue(prio, 0), ^{
        block();
    });
}
