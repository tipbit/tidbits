//
//  NSJSONSerialization+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 4/27/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "Dispatch.h"
#import "NSObject+MTJSONUtils.h"
#import "NSString+Misc.h"
#import "TBAsserts.h"

#import "NSJSONSerialization+Misc.h"


@implementation NSJSONSerialization (Misc)


+(id)JSONObjectFromBundle:(NSBundle *)bundle resourceName:(NSString *)resourceName error:(NSError * __autoreleasing *)error __attribute__((nonnull(1,2))) {
    NSParameterAssert(bundle);
    NSParameterAssert(resourceName);

    NSString * path = [bundle pathForResource:resourceName ofType:@"json"];
    if (path == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:nil];
        }
        return nil;
    }

    NSInputStream * stream = [NSInputStream inputStreamWithFileAtPath:path];
    [stream open];
    id result = [NSJSONSerialization JSONObjectWithStream:stream options:(NSJSONReadingOptions)0 error:error];
    [stream close];
    return  result;
}


+(void)JSONObjectFromBundleAsync:(NSBundle *)bundle resourceName:(NSString *)resourceName onSuccess:(IdBlock)onSuccess onFailure:(NSErrorBlock)onFailure __attribute__((nonnull(1,2,3))) {
    NSParameterAssert(bundle);
    NSParameterAssert(resourceName);
    NSParameterAssert(onSuccess);

    dispatchAsyncBackgroundThread(DISPATCH_QUEUE_PRIORITY_DEFAULT, ^{
        [NSJSONSerialization JSONObjectFromBundleAsyncBackground:bundle resourceName:resourceName onSuccess:onSuccess onFailure:onFailure];
    });
}


+(void)JSONObjectFromBundleAsyncBackground:(NSBundle *)bundle resourceName:(NSString *)resourceName onSuccess:(IdBlock)onSuccess onFailure:(NSErrorBlock)onFailure __attribute__((nonnull(1,2,3))) {
    AssertOnBackgroundThread();

    NSError * err = nil;
    id json = [NSJSONSerialization JSONObjectFromBundle:bundle resourceName:resourceName error:&err];
    if (json == nil) {
        if (onFailure != NULL) {
            onFailure(err);
        }
    }
    else {
        onSuccess(json);
    }
}


+(id)JSONObjectFromFile:(NSString *)filename error:(NSError *__autoreleasing *)error __attribute__((nonnull(1))) {
    NSParameterAssert(filename);

    NSData * data = [NSData dataWithContentsOfFile:filename options:(NSDataReadingOptions)0 error:error];
    if (data == nil) {
        return nil;
    }

    return [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)0 error:error];
}


+(void)JSONObjectFromFileAsync:(NSString *)filename onSuccess:(IdBlock)onSuccess onFailure:(NSErrorBlock)onFailure __attribute__((nonnull(1,2))) {
    NSParameterAssert(filename);
    NSParameterAssert(onSuccess);

    dispatchAsyncBackgroundThread(DISPATCH_QUEUE_PRIORITY_DEFAULT, ^{
        [NSJSONSerialization JSONObjectFromFileAsyncBackground:filename onSuccess:onSuccess onFailure:onFailure];
    });
}


+(void)JSONObjectFromFileAsyncBackground:(NSString *)filename onSuccess:(IdBlock)onSuccess onFailure:(NSErrorBlock)onFailure __attribute__((nonnull(1,2))) {
    AssertOnBackgroundThread();

    NSError * err = nil;
    id json = [NSJSONSerialization JSONObjectFromFile:filename error:&err];
    if (json == nil) {
        if (onFailure != NULL) {
            onFailure(err);
        }
    }
    else {
        onSuccess(json);
    }
}


+(NSString *)stringWithJSONObject:(id)obj error:(NSError *__autoreleasing *)error {
    return [NSJSONSerialization stringWithJSONObject:obj options:0 error:error];
}


+(NSString *)stringWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError *__autoreleasing *)error {
    return [NSString stringWithUTF8Data:[NSJSONSerialization dataWithJSONObject:obj options:opt error:error]];
}


+(NSString *)stringWithJSONObjectMadeSafe:(id)obj error:(NSError *__autoreleasing *)error {
    return [NSJSONSerialization stringWithJSONObject:[obj objectWithJSONSafeObjects] options:0 error:error];
}


+(NSString *)stringWithJSONObjectMadeSafe:(id)obj options:(NSJSONWritingOptions)opt error:(NSError *__autoreleasing *)error {
    return [NSString stringWithUTF8Data:[NSJSONSerialization dataWithJSONObject:[obj objectWithJSONSafeObjects] options:opt error:error]];
}


@end
