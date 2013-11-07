//
//  RunLoopFuture.m
//  Tidbits
//
//  Created by Ewan Mellor on 10/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "Dispatch.h"
#import "TBAsserts.h"

#import "RunLoopFuture.h"


@implementation RunLoopFuture {
    /**
     * This instance retains itself through this variable for the duration of the waitWithInterval call.
     */
    RunLoopFuture* thisSelf;
}


-(void)setValue:(id)value {
    AssertOnMainThread();
    assert(value != nil);
    _value = value;
}


-(void)waitWithInterval:(NSTimeInterval)interval timeout:(NSTimeInterval)timeout onSuccess:(RunLoopFutureIdBlock)onSuccess onTimeout:(RunLoopFutureBlock)onTimeout __attribute__((nonnull)) {
    AssertOnMainThread();
    NSParameterAssert(onSuccess);
    NSParameterAssert(onTimeout);

    thisSelf = self;
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    [self waitWithInterval:interval timeout:timeout start:start onSuccess:onSuccess onTimeout:onTimeout];
}


-(void)waitWithInterval:(NSTimeInterval)interval timeout:(NSTimeInterval)timeout start:(NSTimeInterval)start onSuccess:(RunLoopFutureIdBlock)onSuccess onTimeout:(RunLoopFutureBlock)onTimeout __attribute__((nonnull)) {

    RunLoopFuture* __weak weakSelf = self;

    if (self.value == nil && [NSDate timeIntervalSinceReferenceDate] - start <= timeout) {
        dispatchAsyncMainThreadWithDelay((int)(interval * 1000), ^{
            [weakSelf waitWithInterval:interval timeout:timeout start:start onSuccess:onSuccess onTimeout:onTimeout];
        });
        return;
    }

    id val = self.value;
    dispatchAsyncMainThread(^{
        [weakSelf complete:val onSuccess:onSuccess onTimeout:onTimeout];
    });
}


-(void)complete:(id)val onSuccess:(RunLoopFutureIdBlock)onSuccess onTimeout:(RunLoopFutureBlock)onTimeout {
    thisSelf = nil;
    if (val)
        onSuccess(self, val);
    else
        onTimeout(self);
}


@end
