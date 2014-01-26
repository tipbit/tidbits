//
//  NSRegularExpression+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 1/26/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSRegularExpression+Misc.h"


@implementation NSRegularExpression (Misc)


+(instancetype)wordPrefixCaseInsensitive:(NSString *)wordPrefix {
    if (wordPrefix.length == 0)
        return nil;

    NSString* escaped_wordPrefix = [NSRegularExpression escapedPatternForString:wordPrefix];
    NSError* err = nil;
    NSRegularExpression* result =
        [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"\\b%@", escaped_wordPrefix]
                                                  options:NSRegularExpressionCaseInsensitive | NSRegularExpressionUseUnicodeWordBoundaries
                                                    error:&err];
    assert(err == nil);

    return result;
}


-(bool)hasMatchInString:(NSString *)string {
    return string == nil ? false : [self hasMatchInString:string options:0 range:NSMakeRange(0, string.length)];
}


-(bool)hasMatchInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range {
    return string == nil ? false : (nil != [self firstMatchInString:string options:options range:range]);
}


@end
