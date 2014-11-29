//
//  Batcher.m
//  Tidbits
//
//  Created by Ewan Mellor on 11/29/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "Batcher.h"


@interface Batcher ()

@property (nonatomic, readonly) NSTimeInterval minDelay;
@property (nonatomic, readonly) NSTimeInterval maxDelay;
@property (nonatomic, readonly) NSMutableArrayBlock onBatch;

/**
 * May only be accessed under @synchronized (self).
 */
@property (nonatomic) NSMutableArray * objectArray;

/**
 * May only be accessed under @synchronized (self).
 */
@property (nonatomic) NSTimeInterval firstInsertion;

@end


@implementation Batcher


-(instancetype)initWithMinDelay:(NSTimeInterval)minDelay maxDelay:(NSTimeInterval)maxDelay onBatch:(NSMutableArrayBlock)onBatch __attribute__((nonnull)) {
    NSParameterAssert(minDelay > 0.0);
    NSParameterAssert(maxDelay > 0.0);
    NSParameterAssert(onBatch);

    self = [super init];
    if (self) {
        _minDelay = minDelay;
        _maxDelay = maxDelay;
        _onBatch = onBatch;
    }
    return self;
}


-(void)addObject:(id)object __attribute__((nonnull)) {
    NSParameterAssert(object);

    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];

    @synchronized (self) {
        if (self.objectArray == nil) {
            self.objectArray = [NSMutableArray arrayWithObject:object];
            self.firstInsertion = now;
            [self performSelector:@selector(sendBatch) withObject:nil afterDelay:self.minDelay];
        }
        else {
            [self.objectArray addObject:object];
            NSTimeInterval delta = now - self.firstInsertion;
            NSTimeInterval diff = self.maxDelay - delta;
            if (diff > 0) {
                // This batch can wait a bit longer.
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendBatch) object:nil];
                NSTimeInterval newDelay = MIN(diff, self.minDelay);
                [self performSelector:@selector(sendBatch) withObject:nil afterDelay:newDelay];
            }
            else {
                // This batch is going as soon as its timer fires, which is any moment now.
            }
        }
    }
}


-(void)sendBatch {
    NSMutableArray * batch;
    @synchronized (self) {
        batch = self.objectArray;
        self.objectArray = nil;
    }
    self.onBatch(batch);
}


@end
