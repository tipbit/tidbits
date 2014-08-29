//
//  NSMutableString+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 2/28/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (Misc)

/**
 * If aString is nil, do nothing.  Otherwise, call [self appendString:aString].
 */
-(void)appendStringOrNil:(NSString *)aString;

/**
 * Call replaceOccurrencesOfString for each of the key-value pairs in replacements,
 * replacing all occurrences of the key with the value.
 *
 * This will happen in indeterminate order, so don't have keys that appear in the values.
 *
 * @param replacements May be nil or empty, in which case nothing happens.
 */
-(void)replaceAll:(NSDictionary *)replacements;

/**
 * Equivalent to [self replaceOccurrencesOfString:target withString:replacement options:0 range:NSMakeRange(0, self.length)].
 */
-(void)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement;


@end
