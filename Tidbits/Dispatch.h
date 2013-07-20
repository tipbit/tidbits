//
//  Dispatch.h
//  TBClientLib
//
//  Created by Ewan Mellor on 5/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DURATION_WARNING_ENABLED DEBUG

#if DURATION_WARNING_ENABLED
#define DURATION_WARNING_EXTRA_ARGS const char* func, int line,
#else
#define DURATION_WARNING_EXTRA_ARGS
#endif

typedef id (^dispatch_block_with_result_t)(void);

void dispatchSyncMainThread(DURATION_WARNING_EXTRA_ARGS dispatch_block_t block);
void dispatchAsyncMainThread(DURATION_WARNING_EXTRA_ARGS dispatch_block_t block);
void dispatchAsyncMainThreadWithDelay(DURATION_WARNING_EXTRA_ARGS int delay_msec, dispatch_block_t block);

id dispatchSyncMainThreadWithResult(DURATION_WARNING_EXTRA_ARGS dispatch_block_with_result_t block);

void dispatchAsyncBackgroundThread(dispatch_queue_priority_t prio, dispatch_block_t block);


#if DURATION_WARNING_ENABLED
#define dispatchSyncMainThread(...) dispatchSyncMainThread(__PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#define dispatchAsyncMainThread(...) dispatchAsyncMainThread(__PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#define dispatchAsyncMainThreadWithDelay(__delay, ...) dispatchAsyncMainThreadWithDelay(__PRETTY_FUNCTION__, __LINE__, __delay, ## __VA_ARGS__)
#define dispatchSyncMainThreadWithResult(...) dispatchSyncMainThreadWithResult(__PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#endif
