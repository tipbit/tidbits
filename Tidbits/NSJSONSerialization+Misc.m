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
