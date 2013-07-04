//
//  OperationManager.m
//  TBClientLib
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


-(void)performNSData:(id<NSCopying>)key onSuccess:(NSDataBlock)onSuccess onFailure:(NSErrorBlock)onFailure op:(NSDataOperationBlock)op {
    CallbackPair* cb = [[CallbackPair alloc] initNSData:onSuccess onFailure:onFailure];

    bool inProgress = [self recordCallbackPair:key callbackPair:cb];
    if (!inProgress) {
        op(^(NSData* data) {
            [self performSuccessNSData:key data:data];
        }, ^(NSError* err) {
            [self performFailure:key error:err];
        });
    }
}


-(void)performVoid:(id<NSCopying>)key onSuccess:(VoidBlock)onSuccess onFailure:(NSErrorBlock)onFailure op:(VoidOperationBlock)op {
    CallbackPair* cb = [[CallbackPair alloc] initVoid:onSuccess onFailure:onFailure];

    bool inProgress = [self recordCallbackPair:key callbackPair:cb];
    if (!inProgress) {
        op(^{
            [self performSuccessVoid:key];
        }, ^(NSError* err) {
            [self performFailure:key error:err];
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


-(void)performSuccessNSData:(id<NSCopying>)key data:(NSData*)data {
    NSArray* callbacks;
    @synchronized (operations) {
        callbacks = operations[key];
        [operations removeObjectForKey:key];
    }
    for (CallbackPair* callback in callbacks) {
        callback.onSuccessNSData(data);
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
