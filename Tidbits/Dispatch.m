//
//  Dispatch.m
//  TBClientLib
//
//  Created by Ewan Mellor on 5/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "Dispatch.h"

void dispatchSyncMainThread(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        @try {
            block();
        }
        @catch (NSException* exn) {
            NSLog(@"Ignoring exception in dispatchSyncMainThread: %@ %@", exn.description, exn.callStackSymbols);
        }
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            @try {
                block();
            }
            @catch (NSException* exn) {
                NSLog(@"Ignoring exception in dispatchSyncMainThread: %@ %@", exn.description, exn.callStackSymbols);
            }
        });
    }
}


id dispatchSyncMainThreadWithResult(dispatch_block_with_result_t block) {
    if ([NSThread isMainThread]) {
        @try {
            return block();
        }
        @catch (NSException* exn) {
            NSLog(@"Ignoring exception in dispatchSyncMainThread: %@ %@", exn.description, exn.callStackSymbols);
        }
    }
    else {
        __block id result = nil;
        dispatch_sync(dispatch_get_main_queue(), ^{
            @try {
                result = block();
            }
            @catch (NSException* exn) {
                NSLog(@"Ignoring exception in dispatchSyncMainThread: %@ %@", exn.description, exn.callStackSymbols);
            }
        });
        return result;
    }
}


void dispatchAsyncMainThread(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            block();
        }
        @catch (NSException* exn) {
            NSLog(@"Ignoring exception in dispatchAsyncMainThread: %@ %@", exn.description, exn.callStackSymbols);
        }
    });
}

#define DISPATCH_MSEC_FROM_NOW(__ms) (dispatch_time(DISPATCH_TIME_NOW, ((int64_t)__ms) * NSEC_PER_MSEC))

void dispatchAsyncMainThreadWithDelay(int delay_msec, dispatch_block_t block) {
    dispatch_after(DISPATCH_MSEC_FROM_NOW(delay_msec), dispatch_get_main_queue(), ^{
        @try {
            block();
        }
        @catch (NSException* exn) {
            NSLog(@"Ignoring exception in dispatchAsyncMainThreadWithDelay: %@ %@", exn.description, exn.callStackSymbols);
        }
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
