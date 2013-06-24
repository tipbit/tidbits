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


-(bool)endsWith:(NSString *)comparand {
    if (comparand.length > self.length)
        return false;
    NSString* bit = [self substringFromIndex:self.length - comparand.length];
    return [bit isEqualToString:comparand];
}


-(bool)endsWithCaseInsensitive:(NSString *)comparand {
    if (comparand.length > self.length)
        return false;
    NSString* bit = [self substringFromIndex:self.length - comparand.length];
    return [bit caseInsensitiveCompare:comparand] == NSOrderedSame;
}


-(bool)endsWithChar:(unichar)c {
    return self.length == 0 ? false : c == [self characterAtIndex:self.length - 1];
}


-(bool)isEqualToStringCaseInsensitive:(NSString *)comparand {
    return [self caseInsensitiveCompare:comparand] == NSOrderedSame;
}


-(bool)startsWith:(NSString *)comparand {
    if (comparand.length > self.length)
        return false;
    NSString* bit = [self substringToIndex:comparand.length];
    return [bit isEqualToString:comparand];
}


-(bool)startsWithCaseInsensitive:(NSString *)comparand {
    if (comparand.length > self.length)
        return false;
    NSString* bit = [self substringToIndex:comparand.length];
    return [bit caseInsensitiveCompare:comparand] == NSOrderedSame;
}


-(bool)startsWithChar:(unichar)c {
    return self.length == 0 ? false : c == [self characterAtIndex:0];
}


-(NSString*)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


+(NSString *)stringWithUTF8Data:(NSData *)data {
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


@end
