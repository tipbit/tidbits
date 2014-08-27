//
//  NSThread+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/26/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSThread+Misc.h"

@implementation NSThread (Misc)


static NSRegularExpression * funcFromCallstackRE;
+(void)load {
    NSError * err = nil;
    funcFromCallstackRE = [NSRegularExpression regularExpressionWithPattern:@"^\\S+\\s+\\S+\\s+\\S+\\s+(.+) \\+.*$"
                                                                    options:0 error:&err];
    assert(funcFromCallstackRE != nil);
    assert(err == nil);
}


+(NSString *)callingFunction {
    NSArray * callStack = [NSThread callStackSymbols];
    return callStack.count < 3 ? @"No calling function in callstack!" : [NSThread functionFromCallstackLine:callStack[2]];
}


+(NSString *)functionFromCallstackLine:(NSString *)line {
    NSArray * arr = [funcFromCallstackRE matchesInString:line options:0 range:NSMakeRange(0, line.length)];
    if (arr.count != 1) {
        return line;
    }

    NSTextCheckingResult * res = arr[0];
    return [line substringWithRange:[res rangeAtIndex:1]];
}


@end
