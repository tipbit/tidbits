//
//  NSJSONSerialization+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 4/27/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StandardBlocks.h"


@interface NSJSONSerialization (Misc)

/**
 * Equivalent to [NSJSONSerialization JSONObjectWithStream:stream options:0 error:error],
 * where the stream is from opening resourceName.json from the given bundle.
 */
+(id)JSONObjectFromBundle:(NSBundle *)bundle resourceName:(NSString *)resourceName error:(NSError * __autoreleasing *)error __attribute__((nonnull(1,2)));

/**
 * Call [NSJSONSerialization JSONObjectFromBundle:bundle resourceName:resourceName: error:] on a background
 * thread, and call back with the result.
 *
 * @param onSuccess Called on the background thread.  May not be NULL.
 * @param onFailure Called on the background thread.  May be NULL.
 */
+(void)JSONObjectFromBundleAsync:(NSBundle *)bundle resourceName:(NSString *)resourceName onSuccess:(IdBlock)onSuccess onFailure:(NSErrorBlock)onFailure __attribute__((nonnull(1,2,3)));

/**
 * Equivalent to [NSJSONSerialization JSONObjectWithStream:stream options:0 error:error],
 * where the stream is from opening resourceName.json from the given bundle.
 */
+(id)JSONObjectFromFile:(NSString *)filename error:(NSError * __autoreleasing *)error __attribute__((nonnull(1)));

/**
 * Call [NSJSONSerialization JSONObjectFromBundle:bundle resourceName:resourceName: error:] on a background
 * thread, and call back with the result.
 *
 * @param onSuccess Called on the background thread.  May not be NULL.
 * @param onFailure Called on the background thread.  May be NULL.
 */
+(void)JSONObjectFromFileAsync:(NSString *)filename onSuccess:(IdBlock)onSuccess onFailure:(NSErrorBlock)onFailure __attribute__((nonnull(1,2)));

/**
 * Equivalent to [NSJSONSerialization stringWithJSONObject:obj options:0 error:error].
 */
+(NSString *)stringWithJSONObject:(id)obj error:(NSError *__autoreleasing *)error;

/**
 * Equivalent to [NSString stringWithUTF8Data:[NSJSONSerialization dataWithJSONObject:obj options:opt error:error]].
 */
+(NSString *)stringWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError *__autoreleasing *)error;

/**
 * Equivalent to [NSJSONSerialization stringWithJSONObject:[obj objectWithJSONSafeObjects] options:0 error:error].
 */
+(NSString *)stringWithJSONObjectMadeSafe:(id)obj error:(NSError *__autoreleasing *)error;

/**
 * Equivalent to [NSString stringWithUTF8Data:[NSJSONSerialization dataWithJSONObject:[obj objectWithJSONSafeObjects] options:opt error:error]].
 */
+(NSString *)stringWithJSONObjectMadeSafe:(id)obj options:(NSJSONWritingOptions)opt error:(NSError *__autoreleasing *)error;

@end
