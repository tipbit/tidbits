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


@implementation RunLoopFuture


-(void)setValue:(id)value {
    AssertOnMainThread();
    assert(value != nil);
    _value = value;
}


-(void)waitWithInterval:(NSTimeInterval)interval timeout:(NSTimeInterval)timeout onSuccess:(RunLoopFutureIdBlock)onSuccess onTimeout:(RunLoopFutureBlock)onTimeout __attribute__((nonnull)) {
    AssertOnMainThread();
    NSParameterAssert(onSuccess);
    NSParameterAssert(onTimeout);

    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    while (self.value == nil && [NSDate timeIntervalSinceReferenceDate] - start <= timeout)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:interval]];

    id val = self.value;
    RunLoopFuture* __weak weakSelf = self;
    dispatchAsyncMainThread(^{
        RunLoopFuture* myself = weakSelf;
        if (myself == nil)
            return;

        if (val)
            onSuccess(myself, val);
        else
            onTimeout(myself);
    });
}


@end
