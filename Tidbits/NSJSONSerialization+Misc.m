//
//  NSJSONSerialization+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 4/27/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSObject+MTJSONUtils.h"
#import "NSString+Misc.h"

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
