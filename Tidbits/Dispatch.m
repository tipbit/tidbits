//
//  Dispatch.m
//  TBClientLib
//
//  Created by Ewan Mellor on 5/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "Dispatch.h"
#import "LoggingMacros.h"


#define DURATION_WARNING_ENABLED DEBUG
#define DURATION_WARNING_THRESHOLD 0.3


#if DURATION_WARNING_ENABLED

#define DURATION_WARNING_GET_SYMBOLS \
    NSArray* symbols = [NSThread callStackSymbols]

#define DURATION_WARNING_START \
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate]

#define DURATION_WARNING_END \
    do { \
        NSTimeInterval duration = [NSDate timeIntervalSinceReferenceDate] - start; \
        if (duration > DURATION_WARNING_THRESHOLD) \
            durationWarning(duration, symbols); \
    } while (false)

// This is a separate function from the macro above so that you can stick a breakpoint here.
static void durationWarning(NSTimeInterval duration, NSArray* symbols) {
    DLog(@"Operation on main thread took %0.6lf secs.  Call-stack: %@", duration, symbols);
}

#else

#define DURATION_WARNING_GET_SYMBOLS
#define DURATION_WARNING_START
#define DURATION_WARNING_END

#endif


void dispatchSyncMainThread(dispatch_block_t block) {
    DURATION_WARNING_GET_SYMBOLS;

    if ([NSThread isMainThread]) {
        DURATION_WARNING_START;

        @try {
            block();
        }
        @catch (NSException* exn) {
            NSLog(@"Ignoring exception in dispatchSyncMainThread: %@ %@", exn.description, exn.callStackSymbols);
        }

        DURATION_WARNING_END;
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            DURATION_WARNING_START;

            @try {
                block();
            }
            @catch (NSException* exn) {
                NSLog(@"Ignoring exception in dispatchSyncMainThread: %@ %@", exn.description, exn.callStackSymbols);
            }

            DURATION_WARNING_END;
        });
    }

}


id dispatchSyncMainThreadWithResult(dispatch_block_with_result_t block) {
    DURATION_WARNING_GET_SYMBOLS;

    if ([NSThread isMainThread]) {
        DURATION_WARNING_START;

        @try {
            return block();
        }
        @catch (NSException* exn) {
            NSLog(@"Ignoring exception in dispatchSyncMainThread: %@ %@", exn.description, exn.callStackSymbols);
        }

        DURATION_WARNING_END;
    }
    else {
        __block id result = nil;
        dispatch_sync(dispatch_get_main_queue(), ^{
            DURATION_WARNING_START;

            @try {
                result = block();
            }
            @catch (NSException* exn) {
                NSLog(@"Ignoring exception in dispatchSyncMainThread: %@ %@", exn.description, exn.callStackSymbols);
            }

            DURATION_WARNING_END;
        });
        return result;
    }
}


void dispatchAsyncMainThread(dispatch_block_t block) {
    DURATION_WARNING_GET_SYMBOLS;

    dispatch_async(dispatch_get_main_queue(), ^{
        DURATION_WARNING_START;

        @try {
            block();
        }
        @catch (NSException* exn) {
            NSLog(@"Ignoring exception in dispatchAsyncMainThread: %@ %@", exn.description, exn.callStackSymbols);
        }

        DURATION_WARNING_END;
    });
}

#define DISPATCH_MSEC_FROM_NOW(__ms) (dispatch_time(DISPATCH_TIME_NOW, ((int64_t)__ms) * NSEC_PER_MSEC))

void dispatchAsyncMainThreadWithDelay(int delay_msec, dispatch_block_t block) {
    DURATION_WARNING_GET_SYMBOLS;

    dispatch_after(DISPATCH_MSEC_FROM_NOW(delay_msec), dispatch_get_main_queue(), ^{
        DURATION_WARNING_START;

        @try {
            block();
        }
        @catch (NSException* exn) {
            NSLog(@"Ignoring exception in dispatchAsyncMainThreadWithDelay: %@ %@", exn.description, exn.callStackSymbols);
        }

        DURATION_WARNING_END;
    });
}


void dispatchAsyncBackgroundThread(dispatch_queue_priority_t prio, dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(prio, 0), ^{
        @try {
            block();
        }
        @catch (NSException* exn) {
            NSLog(@"Ignoring exception in dispatchAsyncBackgroundThread: %@ %@", exn.description, exn.callStackSymbols);
        }
    });
}
