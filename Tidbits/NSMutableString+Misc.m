//
//  NSMutableString+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 2/28/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSMutableString+Misc.h"

@implementation NSMutableString (Misc)


-(void)appendStringOrNil:(NSString *)aString {
    if (aString != nil)
        [self appendString:aString];
}


-(void)replaceAll:(NSDictionary *)replacements {
    [replacements enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * value, __unused BOOL * stop) {
        [self replaceOccurrencesOfString:key withString:value options:0 range:NSMakeRange(0, self.length)];
    }];
}


@end
