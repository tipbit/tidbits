//
//  NSString+IsNotWhitespace.m
//  Tipbit
//
//  Created by Ewan Mellor on 4/12/13.
//  Copyright (c) 2013 Tipbit. All rights reserved.
//

#import "NSString+IsNotWhitespace.h"

@implementation NSString (IsNotWhitespace)

- (BOOL) isNotWhitespace {
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0;
}

@end
