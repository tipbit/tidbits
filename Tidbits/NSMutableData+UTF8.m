//
//  NSMutableData+UTF8.m
//  wbxml-ios
//
//  Created by Ewan Mellor on 4/22/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "stdarg.h"

#import "NSMutableData+UTF8.h"

@implementation NSMutableData (UTF8)

-(void) appendUTF8:(NSString *)s {
    [self appendData:[s dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void) appendUTF8Format:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [self appendUTF8:[[NSString alloc] initWithFormat:format arguments:args]];
    va_end(args);
}

@end
