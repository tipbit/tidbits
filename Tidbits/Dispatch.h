//
//  Dispatch.h
//  TBClientLib
//
//  Created by Ewan Mellor on 5/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^dispatch_block_with_result_t)(void);

void dispatchSyncMainThread(dispatch_block_t block);
void dispatchAsyncMainThread(dispatch_block_t block);
void dispatchAsyncMainThreadWithDelay(int delay_msec, dispatch_block_t block);

id dispatchSyncMainThreadWithResult(dispatch_block_with_result_t block);

void dispatchAsyncBackgroundThread(dispatch_queue_priority_t prio, dispatch_block_t block);
