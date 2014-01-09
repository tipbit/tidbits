//
//  RunLoopFuture.h
//  Tidbits
//
//  Created by Ewan Mellor on 10/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StandardBlocks.h"


@class RunLoopFuture;
typedef void (^RunLoopFutureBlock)(RunLoopFuture* future);
typedef void (^RunLoopFutureIdBlock)(RunLoopFuture* future, id value);


/**
 * A RunLoopFuture is a placeholder for a result that is going to be computed using GCD on the main thread.  If the value has not yet been computed,
 * waitWithInterval will poll using dispatchAsyncMainThreadWithDelay until it is.
 *
 * To use this, create a RunLoopFuture, then start a GCD-based process which will set RunLoopFuture.value when it is done.  Call waitWithInterval
 * at some later point to use that value.
 *
 * You may not set value to nil, since nil indicates "not yet set".  Use [NSNull null] if you have to.
 */
@interface RunLoopFuture : NSObject

@property (nonatomic, strong) id value;

/**
 * Wait for self.value to be set.  Use dispatchAsyncMainThreadWithDelay to come back later if self.value is not yet set, and do that until timeout.
 *
 * Precisely one of onSuccess or onTimeout will be called.  This call will be async dispatched to the main thread.
 *
 * onSuccess receives self.value as its second parameter.
 */
-(void)waitWithInterval:(NSTimeInterval)interval timeout:(NSTimeInterval)timeout onSuccess:(RunLoopFutureIdBlock)onSuccess onTimeout:(RunLoopFutureBlock)onTimeout __attribute__((nonnull));

@end
