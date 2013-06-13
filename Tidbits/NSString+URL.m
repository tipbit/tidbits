//
//  NSString+URL.m
//  TBClientLib
//
//  Created by Ewan Mellor on 5/22/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

-(NSString*) stringByURLEscaping {
    NSMutableString *output = [[NSMutableString alloc] init];
    
    int sourceLen = [self length];
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = [self characterAtIndex:i];
        if (thisChar == ' ') {
            [output appendString:@"+"];
        }
        else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                 (thisChar >= 'a' && thisChar <= 'z') ||
                 (thisChar >= 'A' && thisChar <= 'Z') ||
                 (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        }
        else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    
    return output;
}


@end
