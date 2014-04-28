//
//  NSJSONSerialization+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 4/27/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSJSONSerialization (Misc)

/**
 * Equivalent to [NSJSONSerialization stringWithJSONObject:obj options:0 error:error].
 */
+(NSString *)stringWithJSONObject:(id)obj error:(NSError *__autoreleasing *)error;

/**
 * Equivalent to [NSString stringWithUTF8Data:[NSJSONSerialization dataWithJSONObject:obj options:opt error:error]].
 */
+(NSString *)stringWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError *__autoreleasing *)error;

@end
