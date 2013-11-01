//
//  OperationManager.m
//  Tidbits
//
//  Created by Ewan Mellor on 7/4/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "OperationManager.h"


@interface CallbackPair : NSObject

@property (nonatomic, copy) NSDataBlock onSuccessNSData;
@property (nonatomic, copy) VoidBlock onSuccessVoid;
@property (nonatomic, copy) NSErrorBlock onFailure;

-(instancetype)initNSData:(NSDataBlock)onSuccess onFailure:(NSErrorBlock)onFailure;
-(instancetype)initVoid:(VoidBlock)onSuccess onFailure:(NSErrorBlock)onFailure;

@end


@implementation CallbackPair

-(instancetype)initNSData:(NSDataBlock)onSuccess onFailure:(NSErrorBlock)onFailure {
    self = [super init];
    if (self) {
        self.onSuccessNSData = onSuccess;
        self.onFailure = onFailure;
    }
    return self;
}

-(instancetype)initVoid:(VoidBlock)onSuccess onFailure:(NSErrorBlock)onFailure {
    self = [super init];
    if (self) {
        self.onSuccessVoid = onSuccess;
        self.onFailure = onFailure;
    }
    return self;
}

@end


@implementation OperationManager {
    NSMutableDictionary* operations;
}


-(id)init {
    self = [super init];
    if (self) {
        operations = [NSMutableDictionary dictionary];
    }
    return self;
}


-(void)performNSData:(NSUInteger)key onSuccess:(NSDataBlock)onSuccess onFailure:(NSErrorBlock)onFailure op:(NSDataOperationBlock)op {
    CallbackPair* cb = [[CallbackPair alloc] initNSData:onSuccess onFailure:onFailure];

    bool inProgress = [self recordCallbackPair:key callbackPair:cb];
    if (!inProgress) {
        OperationManager* __weak weakSelf = self;
        op(^(NSData* data) {
            [weakSelf performSuccessNSData:key data:data];
        }, ^(NSError* err) {
            [weakSelf performFailure:key error:err];
        });
    }
}


-(void)performVoid:(NSUInteger)key onSuccess:(VoidBlock)onSuccess onFailure:(NSErrorBlock)onFailure op:(VoidOperationBlock)op {
    CallbackPair* cb = [[CallbackPair alloc] initVoid:onSuccess onFailure:onFailure];

    bool inProgress = [self recordCallbackPair:key callbackPair:cb];
    if (!inProgress) {
        OperationManager* __weak weakSelf = self;
        op(^{
            [weakSelf performSuccessVoid:key];
        }, ^(NSError* err) {
            [weakSelf performFailure:key error:err];
        });
    }
}


-(void)performFailure:(NSUInteger)key error:(NSError*)err {
    NSArray* callbacks;
    NSNumber* key_n = @(key);
    @synchronized (operations) {
        callbacks = operations[key_n];
        [operations removeObjectForKey:key_n];
    }
    for (CallbackPair* callback in callbacks) {
        callback.onFailure(err);
    }
}


-(void)performSuccessNSData:(NSUInteger)key data:(NSData*)data {
    NSArray* callbacks;
    NSNumber* key_n = @(key);
    @synchronized (operations) {
        callbacks = operations[key_n];
        [operations removeObjectForKey:key_n];
    }
    for (CallbackPair* callback in callbacks) {
        callback.onSuccessNSData(data);
    }
}


-(void)performSuccessVoid:(NSUInteger)key {
    NSArray* callbacks;
    NSNumber* key_n = @(key);
    @synchronized (operations) {
        callbacks = operations[key_n];
        [operations removeObjectForKey:key_n];
    }
    for (CallbackPair* callback in callbacks) {
        callback.onSuccessVoid();
    }
}


-(bool)recordCallbackPair:(NSUInteger)key callbackPair:(CallbackPair*)cb {
    NSNumber* key_n = @(key);
    @synchronized (operations) {
        NSMutableArray* callbacks = operations[key_n];
        if (callbacks == nil) {
            callbacks = [NSMutableArray array];
            operations[key_n] = callbacks;
            [callbacks addObject:cb];
            return false;
        }
        else {
            [callbacks addObject:cb];
            return true;
        }
    }
}


@end
