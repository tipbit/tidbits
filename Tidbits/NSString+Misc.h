//
//  NSString+Misc.h
//  Tipbit
//
//  Created by Ewan Mellor on 5/23/13.
//  Copyright (c) 2013 Tipbit. All rights reserved.
//

#import <Foundation/NSDictionary.h>
#import <Foundation/NSString.h>

@interface NSString (Misc)

-(NSArray *)componentsSeparatedByString:(NSString *)separator limit:(NSUInteger)limit;

-(bool) contains:(NSString*)substring;

-(bool) containsCaseInsensitive:(NSString*)substring;

/**
 * @return YES if self contains substring,
 * using NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch.
 */
-(BOOL)containsStringEverythingInsensitive:(NSString *)substring;

-(bool) hasSuffixCaseInsensitive:(NSString *)comparand;

-(bool) hasSuffixChar:(unichar)c;

-(bool) isEqualToStringCaseInsensitive:(NSString*)comparand;

-(bool) hasPrefixCaseInsensitive:(NSString*)comparand;

-(bool) hasPrefixChar:(unichar)c;

-(bool) isEarlierVersionThan:(NSString*)comparand;

-(bool) isNotWhitespace;

-(BOOL)isNotEqualToString:(NSString *)aString;

/**
 * @return true if all characters in this string are in [NSCharacterSet decimalDigitCharacterSet].
 * Note that this is trivially true if the string is empty, but is not true if the string is just whitespace.
 */
-(bool) isAllNumeric;

/**
 * Equivalent to [self keyValuePairsSeparatedBy:@"," and:@"="].
 */
-(NSMutableDictionary<NSString *, NSString *> *)keyValuePairs;

/**
 * Given that self is a string like "a=b,c=d,e=f", return the dictionary @{@"a": @"b", @"c": @"d", @"e": @"f"}.
 *
 * If self is only whitespace, then then the empty dictionary will be returned.
 *
 * All keys and values are trimmed of whitespace at both ends.
 *
 * If the string contains an invalid pair, e.g. @"a=b=c" or @"a" then the full string will be used as the
 * key, and the value will be the empty string e.g. @{@"a=b=c": @""} or @{@"a": @""}.
 *
 * If keys are duplicated then the earlier one will be overwritten by the latter one.
 *
 * @param pairsSeparator The separator between pairs (comma in the example above).
 * @param kvSeparator The separator between key and value (equals in the example above).
 */
-(NSMutableDictionary<NSString *, NSString *> *)keyValuePairsSeparatedBy:(NSString *)pairsSeparator and:(NSString *)kvSeparator;

-(NSString*)trim;

-(unsigned long)unsignedLongValue;

-(NSData*)UTF8Data;

/**
 * @return The bit after the @ (i.e. assuming that this string is an email address).
 * This string must have precisely one @ and it must be in the middle, not at either end.
 * nil otherwise.
 */
-(NSString *)emailDomain;

/**
 * @return The bit before the @ (i.e. assuming that this string is an email address).
 * This string must have precisely one @ and it must be in the middle, not at either end.
 * nil otherwise.
 */
-(NSString *)emailUser;

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

-(NSString *)stringByDeletingCharactersInRange:(NSRange)range;

/**
 * @param charset May be nil, in which case [self copy] is returned.
 */
-(NSString *)stringByDeletingCharactersInSet:(NSCharacterSet *)charset;

/**
 * @return A copy of this string, with [NSMutableString replaceAll:replacements] called on it.
 */
-(NSString *)stringByReplacingAll:(NSDictionary *)replacements;

-(NSString *)stringByStrippingQuotes;

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

/**
 * @param strs NSString array.
 * @return NSString -> NSString.  The key is the string in strs.  The value is the shortest prefix
 * that still uniquely identifies the key in strs.
 */
+(NSDictionary *)uniquePrefixes:(NSArray *)strs;

@end
