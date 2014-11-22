//
//  NSString+Misc.h
//  Tipbit
//
//  Created by Ewan Mellor on 5/23/13.
//  Copyright (c) 2013 Tipbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Misc)

-(bool) contains:(NSString*)substring;

-(bool) containsCaseInsensitive:(NSString*)substring;

-(bool) hasSuffixCaseInsensitive:(NSString *)comparand;

-(bool) hasSuffixChar:(unichar)c;

-(bool) isEqualToStringCaseInsensitive:(NSString*)comparand;

-(bool) hasPrefixCaseInsensitive:(NSString*)comparand;

-(bool) hasPrefixChar:(unichar)c;

-(bool) isEarlierVersionThan:(NSString*)comparand;

-(bool) isNotWhitespace;

/**
 * @return true if all characters in this string are in [NSCharacterSet decimalDigitCharacterSet].
 * Note that this is trivially true if the string is empty, but is not true if the string is just whitespace.
 */
-(bool) isAllNumeric;

-(NSString*)trim;

-(unsigned long)unsignedLongValue;

-(NSData*)UTF8Data;

/*!
 * @return A copy of this string, with characters escaped so that it is suitable for inclusion in a Javascript
 * single-quoted string literal.
 */
-(NSString*)stringForJavascriptSingleQuotes;

/**
 * @return A copy of this string, with double quotes and backslashes escaped so that it is suitable for inclusion
 * in a double-quoted string literal.
 * @discussion This doesn't do anything with line breaks or any other characters, so you'd best have a plan for those.
 */
-(NSString*)stringForDoubleQuotes;

/**
 * @return A copy of this string, with runs of any slashes, backslashes or unprintable characters replaced with a single space.  Whitespace is also trimmed from front and back.
 * @discussion This means that the string can be used as a filename, allowing as many "unusual" characters as possible.
 */
-(NSString*)stringBySanitizingFilename;

/**
 * @return A copy of this string, with any runs of whitespace replaced with a single space.  Whitespace is also trimmed from front and back.
 */
-(NSString*)stringByFoldingWhitespace;

/**
 * @return A copy of this string, with [NSMutableString replaceAll:replacements] called on it.
 */
-(NSString *)stringByReplacingAll:(NSDictionary *)replacements;

/**
 * @return The equivalent of [[NSString stringWithFormat:@"%@ %@", first, last] trim],
 * but with all the cases where first and last are nil handled cleanly, and where any whitespace between the two words is reduced two a single space.
 */
+(NSString *)stringByJoining:(NSString *)first with:(NSString *)last;

+(NSString*)stringWithUTF8Data:(NSData*)data;

/**
 * Equivalent to bytes == NULL ? @"" : [NSString stringWithUTF8String:bytes].
 */
+(NSString*)stringWithUTF8StringOrEmpty:(const char *)bytes;

@end
