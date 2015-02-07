//
//  Dispatch.h
//  TBClientLib
//
//  Created by Ewan Mellor on 5/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StandardBlocks.h"

#define DURATION_WARNING_ENABLED DEBUG

#if DURATION_WARNING_ENABLED
#define DURATION_WARNING_EXTRA_ARGS const char* func, int line,
#else
#define DURATION_WARNING_EXTRA_ARGS
#endif

void dispatchSyncMainThread(DURATION_WARNING_EXTRA_ARGS VoidBlock block);
void dispatchAsyncMainThread(DURATION_WARNING_EXTRA_ARGS VoidBlock block);

/**
 * If block is NULL, do nothing.  Otherwise, call dispatchAsyncMainThread(block).
 */
void dispatchAsyncMainThreadIfSet(DURATION_WARNING_EXTRA_ARGS VoidBlock block);

/**
 * If block is NULL, do nothing.  Otherwise, call dispatchAsyncMainThread(^{ block(error); }).
 */
void dispatchAsyncMainThreadOnFailure(DURATION_WARNING_EXTRA_ARGS NSErrorBlock block, NSError * error);

void dispatchAsyncMainThreadWithDelay(DURATION_WARNING_EXTRA_ARGS int delay_msec, VoidBlock block);

id dispatchSyncMainThreadWithResult(DURATION_WARNING_EXTRA_ARGS GetIdBlock block);

void dispatchAsyncBackgroundThread(dispatch_queue_priority_t prio, VoidBlock block);
void dispatchAsyncBackgroundThreadWithDelay(int delay_msec, dispatch_queue_priority_t prio, VoidBlock block);

#if DURATION_WARNING_ENABLED
#define dispatchSyncMainThread(...) dispatchSyncMainThread(__PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#define dispatchAsyncMainThread(...) dispatchAsyncMainThread(__PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#define dispatchAsyncMainThreadIfSet(...) dispatchAsyncMainThreadIfSet(__PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#define dispatchAsyncMainThreadOnFailure(...) dispatchAsyncMainThreadOnFailure(__PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#define dispatchAsyncMainThreadWithDelay(__delay, ...) dispatchAsyncMainThreadWithDelay(__PRETTY_FUNCTION__, __LINE__, (int)__delay, ## __VA_ARGS__)
#define dispatchSyncMainThreadWithResult(...) dispatchSyncMainThreadWithResult(__PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#endif
