//
//  NSString+Misc.m
//  Tipbit
//
//  Created by Ewan Mellor on 5/23/13.
//  Copyright (c) 2013 Tipbit. All rights reserved.
//

#import <objc/runtime.h>

#import "NSArray+Map.h"
#import "NSArray+Misc.h"
#import "NSMutableString+Misc.h"

#import "NSString+Misc.h"


@implementation NSString (Misc)


static NSRegularExpression * stripQuotesRE = nil;


+(void)load {
    // iOS 8 added containsString.
    // On iOS 7, add a redirect to our tb_containsString method for compat.
    SEL containsStringSEL = NSSelectorFromString(@"containsString:");
    if (![self instancesRespondToSelector:containsStringSEL]) {
        Method containsMethod = class_getInstanceMethod(self, NSSelectorFromString(@"tb_containsString:"));
        class_addMethod(self, containsStringSEL, method_getImplementation(containsMethod), method_getTypeEncoding(containsMethod));
    }

    NSError * error = nil;
    stripQuotesRE = [NSRegularExpression regularExpressionWithPattern:@"^['\"]*(.*?)['\"]*$"
                                                              options:(NSRegularExpressionOptions)0
                                                                error:&error];
    assert(stripQuotesRE != nil && error == nil);
}


-(NSArray *)componentsSeparatedByString:(NSString *)separator limit:(NSUInteger)limit {
    if (limit == 0) {
        return [self componentsSeparatedByString:separator];
    }

    NSUInteger len = self.length;

    if (len == 0) {
        return @[];
    }

    NSUInteger sepLen = separator.length;
    NSUInteger pos = 0;
    NSUInteger count = 0;
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:limit];
    while (pos <= len) {
        count++;
        if (count == limit) {
            [result addObject:[self substringFromIndex:pos]];
            return result;
        }
        NSRange range = [self rangeOfString:separator options:(NSStringCompareOptions)0 range:NSMakeRange(pos, len - pos)];
        NSUInteger sepPos = range.location;
        if (sepPos == NSNotFound) {
            [result addObject:[self substringFromIndex:pos]];
            return result;
        }
        else {
            [result addObject:[self substringWithRange:NSMakeRange(pos, sepPos - pos)]];
            pos = sepPos + sepLen;
        }
    }

    return result;
}


-(BOOL)tb_containsString:(NSString *)aString {
    return [self rangeOfString:aString].location != NSNotFound;
}


-(bool)contains:(NSString *)substring {
    return [self rangeOfString:substring].location != NSNotFound;
}


-(bool)containsCaseInsensitive:(NSString *)substring {
    return [self rangeOfString:substring options:NSCaseInsensitiveSearch].location != NSNotFound;
}


-(bool)hasSuffixCaseInsensitive:(NSString *)comparand {
    if (comparand.length > self.length)
        return false;
    NSString* bit = [self substringFromIndex:self.length - comparand.length];
    return [bit caseInsensitiveCompare:comparand] == NSOrderedSame;
}


-(bool)hasSuffixChar:(unichar)c {
    return self.length == 0 ? false : c == [self characterAtIndex:self.length - 1];
}


-(bool)isEqualToStringCaseInsensitive:(NSString *)comparand {
    return [self caseInsensitiveCompare:comparand] == NSOrderedSame;
}

-(BOOL)isNotEqualToString:(NSString *)aString{
    return ![self isEqualToString:aString];
}

-(bool)hasPrefixCaseInsensitive:(NSString *)comparand {
    if (comparand.length > self.length)
        return false;
    NSString* bit = [self substringToIndex:comparand.length];
    return [bit caseInsensitiveCompare:comparand] == NSOrderedSame;
}


-(bool)hasPrefixChar:(unichar)c {
    return self.length == 0 ? false : c == [self characterAtIndex:0];
}


-(bool)isNotWhitespace {
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0;
}

-(bool)isAllNumeric {
    NSCharacterSet *numericSet = [NSCharacterSet decimalDigitCharacterSet];
    NSUInteger n = self.length;
    for (NSUInteger i = 0; i < n; i++) {
        unichar ch = [self characterAtIndex:i];
        if (![numericSet characterIsMember:ch]) {
            return false;
        }
    }
    return true;
}


-(NSString*)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


-(unsigned long)unsignedLongValue {
    return (unsigned long)[self longLongValue];
}


-(NSData *)UTF8Data {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}


-(NSString *)emailDomain {
    NSArray * bits = [self componentsSeparatedByString:@"@"];
    return (bits.count == 2 && [bits[0] isNotWhitespace] && [bits[1] isNotWhitespace]) ? bits[1] : nil;
}


-(NSString *)emailUser {
    NSArray * bits = [self componentsSeparatedByString:@"@"];
    return (bits.count == 2 && [bits[0] isNotWhitespace] && [bits[1] isNotWhitespace]) ? bits[0] : nil;
}


+(NSString *)stringWithUTF8Data:(NSData *)data {
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


/*
 * http://www.ecma-international.org/ecma-262/5.1/#sec-7.8.4
 * 7.8.4 String Literals
 *
 * A string literal is zero or more characters enclosed in single or double quotes.
 * Each character may be represented by an escape sequence. All characters may appear
 * literally in a string literal except for the closing quote character, backslash,
 * carriage return, line separator, paragraph separator, and line feed.
 * Any character may appear in the form of an escape sequence.
 */
-(NSString *)stringForJavascriptSingleQuotes {
    return [[[[[[self
                 stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"]
                stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"]
               stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"]
              stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"]
             stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"]
            stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
}


-(NSString*)stringForDoubleQuotes {
    return [[self
             stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"]
            stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
}


-(NSString*)stringBySanitizingFilename {
    static NSRegularExpression* stringBySanitizingFilenameRE = nil;
    static dispatch_once_t stringBySanitizingFilenameOnce;
    dispatch_once(&stringBySanitizingFilenameOnce, ^{
        NSError* err = nil;
        stringBySanitizingFilenameRE = [NSRegularExpression regularExpressionWithPattern:@"\\s*[^]\\w !#$%&'()+,.;=@\\[\\^_`{}~-]+\\s*" options:0 error:&err];
        assert(stringBySanitizingFilenameRE && err == nil);
    });

    NSString* s = [stringBySanitizingFilenameRE stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@" "];
    NSArray* bits = [s componentsSeparatedByString:@"."];
    NSArray* trimmed_bits = [bits map:^id(id obj) {
        return [((NSString*)obj) trim];
    }];
    return [trimmed_bits componentsJoinedByString:@"."];
}


-(NSString *)stringByFoldingWhitespace {
    NSCharacterSet * cset = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [[[[self componentsSeparatedByCharactersInSet:cset] filteredArrayUsingBlock:^bool(NSString * str) {
        return [str isNotWhitespace];
    }] componentsJoinedByString:@" "] trim];
}


-(NSString *)stringByDeletingCharactersInRange:(NSRange)range {
    NSMutableString * result = [self mutableCopy];
    [result deleteCharactersInRange:range];
    return result;
}


-(NSString *)stringByDeletingCharactersInSet:(NSCharacterSet *)charset {
    return charset == nil ? [self copy] : [[self componentsSeparatedByCharactersInSet:charset] componentsJoinedByString:@""];
}


-(NSString *)stringByReplacingAll:(NSDictionary *)replacements {
    NSMutableString * result = [self mutableCopy];
    [result replaceAll:replacements];
    return result;
}


-(bool)isEarlierVersionThan:(NSString *)comparand {
    return [self compare:comparand options:NSNumericSearch] == NSOrderedAscending;
}


+(NSString *)stringByJoining:(NSString *)first with:(NSString *)last {
    bool first_is_not_whitespace = [first isNotWhitespace];
    bool last_is_not_whitespace = [last isNotWhitespace];

    if (first_is_not_whitespace && last_is_not_whitespace) {
        return [NSString stringWithFormat:@"%@ %@", [first trim], [last trim]];
    }
    else if (first_is_not_whitespace) {
        return [first trim];
    }
    else if (last_is_not_whitespace) {
        return [last trim];
    }
    else {
        return @"";
    }
}


-(NSString *)stringByStrippingQuotes {
    if (![self isNotWhitespace]) {
        return @"";
    }

    NSTextCheckingResult * match = [stripQuotesRE firstMatchInString:self options:(NSMatchingOptions)0 range:NSMakeRange(0, self.length)];
    NSRange range = [match rangeAtIndex:1];
    NSString * result = (range.length == self.length ? self : [self substringWithRange:range]);
    return [result trim];
}


+(NSString *)stringWithUTF8StringOrEmpty:(const char *)bytes {
    return bytes == NULL ? @"" : [NSString stringWithUTF8String:bytes];
}


+(NSDictionary *)uniquePrefixes:(NSArray *)strs {
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    for (NSString * str in strs) {
        result[str] = uniquePrefixFor(str, strs);
    }
    return result;
}


static NSString * uniquePrefixFor(NSString * str, NSArray * strs) {
    if (str.length < 2) {
        return str;
    }
    for (NSUInteger i = 1; i < str.length; i++) {
        NSString * candidate = [str substringToIndex:i];
        if (occurrencesOfPrefix(candidate, strs) == 1) {
            return candidate;
        }
    }
    return str;
}


static NSUInteger occurrencesOfPrefix(NSString * prefix, NSArray * strs) {
    NSUInteger i = 0;
    for (NSString * s in strs) {
        if ([s hasPrefix:prefix]) {
            i++;
        }
    }
    return i;
}


@end
