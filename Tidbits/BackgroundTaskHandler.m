//
//  BackgroundTaskHandler.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/25/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Dispatch.h"
#import "FeatureMacros.h"
#import "LoggingMacros.h"
#import "TBAsserts.h"

#import "BackgroundTaskHandler.h"


@interface BackgroundTaskHandler ()

@property (nonatomic, copy, readonly) NSString* taskName;

@property (nonatomic, copy, readonly) TaskBlock taskBlock;

/**
 * May only be accessed under @synchronized (self).
 */
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;

/**
 * The number of times that the app has come into the foreground.
 * This is used to tell us to stop the background cleanup tasks if the counter changes.
 * I've seen situations where onBackground queued the task but they didn't run in the timeslice before the app was suspended
 * so they ran after we had resumed to foreground instead.
 */
@property (nonatomic, assign) int foregroundCounter;

@end


static bool _quickBackgroundSwitch;


@implementation BackgroundTaskHandler


+(bool)quickBackgroundSwitch {
    return _quickBackgroundSwitch;
}

+(void)setQuickBackgroundSwitch:(bool)val {
    _quickBackgroundSwitch = val;
}


-(id)init:(NSString*)taskName taskBlock:(TaskBlock)taskBlock {
    NSParameterAssert(taskName);
    NSParameterAssert(taskBlock);

    self = [super init];
    if (self) {
        _taskName = taskName;
        _taskBlock = taskBlock;
        _foregroundCounter = 1;
        _backgroundTaskId = UIBackgroundTaskInvalid;

        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(onBackground)
                       name:UIApplicationDidEnterBackgroundNotification
                     object:nil];

        [center addObserver:self
                   selector:@selector(onForeground)
                       name:UIApplicationWillEnterForegroundNotification
                     object:nil];
    }
    return self;
}


-(void)dealloc {
    dispatchSyncMainThread(^{
        [self dealloc_];
    });
}

-(void)dealloc_ {
    AssertOnMainThread();

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)onForeground {
    self.foregroundCounter++;
    _quickBackgroundSwitch = false;
}


-(void) onBackground {
    if (_quickBackgroundSwitch) {
        DLog(@"Not doing any background work -- quickBackgroundSwitch is set");
        return;
    }

    int thisForegroundCounter = self.foregroundCounter;
    BackgroundTaskHandler* __weak weakSelf = self;

    @synchronized (self) {
        if (self.backgroundTaskId == UIBackgroundTaskInvalid) {
            self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithName:self.taskName expirationHandler:^{
                [weakSelf handleBackgroundTaskExpired];
            }];
            NSLog(@"Started background task %lu", (unsigned long)self.backgroundTaskId);
        }
    }

    dispatchAsyncBackgroundThread(DISPATCH_QUEUE_PRIORITY_DEFAULT, ^{
        [weakSelf onBackground_:thisForegroundCounter];
    });
}


-(void)onBackground_:(int)thisForegroundCounter {
    BackgroundTaskHandler* __weak weakSelf = self;
    self.taskBlock(^bool{
        return [weakSelf gameOver:thisForegroundCounter];
    });
    NSTimeInterval remaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
    NSLog(@"Background task %@ %lu complete with %lf remaining.", self.taskName, (unsigned long)self.backgroundTaskId, remaining > 1e10 ? -1.0 : remaining);
    [self endBackgroundTask];
}


-(void)handleBackgroundTaskExpired {
    NSLogWarn(@"Background task %@ %lu ran out of time!  This should never happen if we're watching for this in the background task.", self.taskName, (unsigned long)self.backgroundTaskId);
    [self endBackgroundTask];
}


-(void)endBackgroundTask {
    @synchronized (self) {
        if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
            NSLog(@"Ended background task %@ %lu.", self.taskName, (unsigned long)self.backgroundTaskId);
            self.backgroundTaskId = UIBackgroundTaskInvalid;
        }
    }
}


-(bool)gameOver:(int)thisForegroundCounter {
    if (self.foregroundCounter != thisForegroundCounter) {
        NSLog(@"Background task %@ did not run to completion; we're foregrounded again.", self.taskName);
        return true;
    }
    if ([[UIApplication sharedApplication] backgroundTimeRemaining] < 0.1) {
        NSLog(@"Background task %@ did not run to completion; we ran out of time.", self.taskName);
        return true;
    }
    return false;
}


@end
