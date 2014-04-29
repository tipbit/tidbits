//
//  OperationManager.m
//  TBClientLib
//
//  Created by Ewan Mellor on 7/4/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "OperationManager.h"


@interface CallbackPair : NSObject

@property (nonatomic, copy) IdBlock onSuccessId;
@property (nonatomic, copy) VoidBlock onSuccessVoid;
@property (nonatomic, copy) NSErrorBlock onFailure;

-(instancetype)initId:(IdBlock)onSuccess onFailure:(NSErrorBlock)onFailure;
-(instancetype)initVoid:(VoidBlock)onSuccess onFailure:(NSErrorBlock)onFailure;

@end


@implementation CallbackPair

-(instancetype)initId:(IdBlock)onSuccess onFailure:(NSErrorBlock)onFailure {
    self = [super init];
    if (self) {
        _onSuccessId = onSuccess;
        _onFailure = onFailure;
    }
    return self;
}

-(instancetype)initVoid:(VoidBlock)onSuccess onFailure:(NSErrorBlock)onFailure {
    self = [super init];
    if (self) {
        _onSuccessVoid = onSuccess;
        _onFailure = onFailure;
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


-(void)performId:(id<NSCopying>)key onSuccess:(IdBlock)onSuccess onFailure:(NSErrorBlock)onFailure op:(IdOperationBlock)op {
    CallbackPair* cb = [[CallbackPair alloc] initId:(IdBlock)onSuccess onFailure:onFailure];

    bool inProgress = [self recordCallbackPair:key callbackPair:cb];
    if (!inProgress) {
        OperationManager* __weak weakSelf = self;
        op(^(id obj) {
            [weakSelf performSuccessId:key obj:obj];
        }, ^(NSError* err) {
            [weakSelf performFailure:key error:err];
        });
    }
}


-(void)performNSData:(id<NSCopying>)key onSuccess:(NSDataBlock)onSuccess onFailure:(NSErrorBlock)onFailure op:(NSDataOperationBlock)op {
    [self performId:key onSuccess:(IdBlock)onSuccess onFailure:onFailure op:(IdOperationBlock)op];
}


-(void)performVoid:(id<NSCopying>)key onSuccess:(VoidBlock)onSuccess onFailure:(NSErrorBlock)onFailure op:(VoidOperationBlock)op {
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


-(void)performFailure:(id<NSCopying>)key error:(NSError*)err {
    NSArray* callbacks;
    @synchronized (operations) {
        callbacks = operations[key];
        [operations removeObjectForKey:key];
    }
    for (CallbackPair* callback in callbacks) {
        callback.onFailure(err);
    }
}


-(void)performSuccessId:(id<NSCopying>)key obj:(id)obj {
    NSArray* callbacks;
    @synchronized (operations) {
        callbacks = operations[key];
        [operations removeObjectForKey:key];
    }
    for (CallbackPair* callback in callbacks) {
        callback.onSuccessId(obj);
    }
}


-(void)performSuccessVoid:(id<NSCopying>)key {
    NSArray* callbacks;
    @synchronized (operations) {
        callbacks = operations[key];
        [operations removeObjectForKey:key];
    }
    for (CallbackPair* callback in callbacks) {
        callback.onSuccessVoid();
    }
}


-(bool)recordCallbackPair:(id<NSCopying>)key callbackPair:(CallbackPair*)cb {
    @synchronized (operations) {
        NSMutableArray* callbacks = operations[key];
        if (callbacks == nil) {
            callbacks = [NSMutableArray array];
            operations[key] = callbacks;
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
