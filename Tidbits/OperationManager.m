//
//  OperationManager.m
//  TBClientLib
//
//  Created by Ewan Mellor on 7/4/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSDate+ISO8601.h"

#import "OperationManager.h"


@interface CallbackPair : NSObject

@property (nonatomic, readonly, copy) IdBlock onSuccessId;
@property (nonatomic, readonly, copy) VoidBlock onSuccessVoid;
@property (nonatomic, readonly, copy) NSErrorBlock onFailure;

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


@interface OperationMetadata : NSObject

/**
 * CallbackPair array.  May only be accessed under @synchronized (self.callbacks).
 */
@property (nonatomic, readonly) NSMutableArray * callbacks;

#if OPERATIONMANAGER_TRACK_OPERATIONS
@property (nonatomic, readonly) NSDate* startedAt;
@property (atomic) NSString * status;
#endif

-(instancetype) init:(CallbackPair *)callback;

@end


@implementation OperationMetadata


-(instancetype)init:(CallbackPair *)callback {
    self = [super init];
    if (self) {
        _callbacks = [NSMutableArray array];
        [_callbacks addObject:callback];
#if OPERATIONMANAGER_TRACK_OPERATIONS
        _startedAt = [NSDate date];
        _status = @"Started";
#endif
    }
    return self;
}


-(void)addCallbackPair:(CallbackPair *)cb {
    @synchronized (self.callbacks) {
        [self.callbacks addObject:cb];
    }
}


#if OPERATIONMANAGER_TRACK_OPERATIONS
-(NSMutableDictionary *)describe {
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    @synchronized (self.callbacks) {
        result[@"callbackCount"] = @(self.callbacks.count);
    }
    result[@"startedAt"] = [self.startedAt iso8601String];
    result[@"status"] = self.status;
    return result;
}
#endif


@end


#if OPERATIONMANAGER_TRACK_OPERATIONS

@interface NSHashTable (OperationManager)

/**
 * A weak cache of OperationManager instances.  This is used for introspection for debugging.
 * Must only be accessed under @synchronized (self).
 */
+(instancetype)operationManagerCache;

@end


static NSHashTable * operationManagerCache = nil;

@implementation NSHashTable (OperationManager)


+(void)load {
    operationManagerCache = [NSHashTable weakObjectsHashTable];
}


+(instancetype)operationManagerCache {
    return operationManagerCache;
}


@end

#endif


@interface OperationManager ()

@property (nonatomic, readonly) NSString * name;

/**
 * id<NSCopying> -> OperationMetadata.  The key is the operation key.  The value is the metadata for this operation.
 * May only be accessed under @synchronized (self.operations).
 */
@property (nonatomic, readonly) NSMutableDictionary * operations;

@end


@implementation OperationManager


-(id)init {
    return [self init:@"Anonymous"];
}


-(id)init:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
        _operations = [NSMutableDictionary dictionary];

#if OPERATIONMANAGER_TRACK_OPERATIONS
        NSHashTable * cache = [NSHashTable operationManagerCache];
        @synchronized (cache) {
            [cache addObject:self];
        }
#endif
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


#if OPERATIONMANAGER_TRACK_OPERATIONS
#define SET_STATUS(__s) [self setOperationStatus:key status:__s]
#else
#define SET_STATUS(__s)
#endif


-(void)performFailure:(id<NSCopying>)key error:(NSError*)err {
#if OPERATIONMANAGER_TRACK_OPERATIONS
    NSString * msg = [NSString stringWithFormat:@"performFailure %@ calling", err.description];
    SET_STATUS(msg);
#endif

    NSArray* callbacks = [self getCallbacks:key];
    for (CallbackPair * callback in callbacks) {
        if (callback.onFailure != NULL) {
            callback.onFailure(err);
        }
    }

#if OPERATIONMANAGER_TRACK_OPERATIONS
    msg = [NSString stringWithFormat:@"performFailure %@ done", err.description];
    SET_STATUS(msg);
#endif
}


-(void)performSuccessId:(id<NSCopying>)key obj:(id)obj {
    SET_STATUS(@"performSuccessId calling");

    NSArray* callbacks = [self getCallbacks:key];
    for (CallbackPair * callback in callbacks) {
        if (callback.onSuccessId != NULL) {
            callback.onSuccessId(obj);
        }
    }

    SET_STATUS(@"performSuccessId done");
}


-(void)performSuccessVoid:(id<NSCopying>)key {
    SET_STATUS(@"performSuccessId calling");

    NSArray* callbacks = [self getCallbacks:key];
    for (CallbackPair * callback in callbacks) {
        if (callback.onSuccessVoid != NULL) {
            callback.onSuccessVoid();
        }
    }
    SET_STATUS(@"performSuccessVoid done");
}


#undef SET_STATUS


/**
 * @return true if the operation is already in progress, false if it needs to be initiated by the caller.
 */
-(bool)recordCallbackPair:(id<NSCopying>)key callbackPair:(CallbackPair*)cb {
    @synchronized (self.operations) {
        OperationMetadata * op = self.operations[key];
        if (op == nil) {
            op = [[OperationMetadata alloc] init:cb];
            self.operations[key] = op;
            return false;
        }
        else {
            [op addCallbackPair:cb];
#if OPERATIONMANAGER_TRACK_OPERATIONS
            op.status = @"In progress";
#endif
            return true;
        }
    }
}


-(NSArray *)getCallbacks:(id<NSCopying>)key {
    @synchronized (self.operations) {
        OperationMetadata * op = self.operations[key];
        [self.operations removeObjectForKey:key];
        return op.callbacks;
    }
}


#if OPERATIONMANAGER_TRACK_OPERATIONS

-(void)setOperationStatus:(id<NSCopying>)key status:(NSString *)status {
    @synchronized (self.operations) {
        OperationMetadata * op = self.operations[key];
        op.status = status;
    }
}


-(NSMutableDictionary *)describe {
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    result[@"name"] = self.name;
    @synchronized (self.operations) {
        NSMutableDictionary * result_ops = [NSMutableDictionary dictionary];
        for (id<NSCopying> key in self.operations) {
            OperationMetadata * operation = self.operations[key];
            NSString * key_str = [(NSObject*)key debugDescription];
            result_ops[key_str] = [operation describe];
        }
        result[@"operations"] = result_ops;
    }
    return result;
}


+(NSMutableArray *)describeAll {
    NSMutableArray * result = [NSMutableArray array];
    NSMutableArray * ops = [NSMutableArray array];

    NSHashTable * cache = [NSHashTable operationManagerCache];
    @synchronized (cache) {
        [ops addObjectsFromArray:cache.allObjects];
    }
    for (OperationManager * op in ops) {
        [result addObject:[op describe]];
    }
    return result;
}

#endif


@end
