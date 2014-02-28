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


@end
