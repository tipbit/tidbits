//
//  NSString+Misc.m
//  Tipbit
//
//  Created by Ewan Mellor on 5/23/13.
//  Copyright (c) 2013 Tipbit. All rights reserved.
//

#import "NSString+Misc.h"

@implementation NSString (Misc)

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

-(NSString*)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


-(NSData *)UTF8Data {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
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
        stringBySanitizingFilenameRE = [NSRegularExpression regularExpressionWithPattern:@"[^]\\w !\"#$%&'()*+,.:;<=>?@\\[\\^_`{|}~-]+" options:0 error:&err];
        assert(stringBySanitizingFilenameRE && err == nil);
    });

    return [[stringBySanitizingFilenameRE stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@" "] trim];
}


-(bool)isEarlierVersionThan:(NSString *)comparand {
    return [self compare:comparand options:NSNumericSearch] == NSOrderedAscending;
}


@end
