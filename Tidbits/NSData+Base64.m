//
//  NSData+Base64.m
//  base64
//
//  Created by Matt Gallagher on 2009/06/03.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

//
// This file includes modifications by Tipbit.  Copyright (c) Tipbit, Inc.  Licensed as above.
//


#import "NSData+Base64.h"
#import <stdio.h>
#import <stdlib.h>
#import <string.h>


static unsigned char strToChar (char a, char b)
{
    char encoder[3] = {'\0','\0','\0'};
    encoder[0] = a;
    encoder[1] = b;
    return (char) strtol(encoder,NULL,16);
}

@implementation NSData (Hex)
+ (NSData *) dataFromHexidecimal: (NSString *)hexString
{
    const char * bytes = [hexString UTF8String];
    NSUInteger length = strlen(bytes);
    unsigned char * r = (unsigned char *) malloc(length / 2 + 1);
    unsigned char * index = r;

    while ((*bytes) && (*(bytes +1))) {
        *index = strToChar(*bytes, *(bytes +1));
        index++;
        bytes+=2;
    }
    *index = '\0';

    NSData * result = [NSData dataWithBytes: r length: length / 2];
    free(r);

    return result;
}

- (NSString *) hexString
{
    NSMutableString *result = [NSMutableString string];
    NSUInteger length = [self length];
    int8_t *bytes = (int8_t *)[self bytes];

    for (NSUInteger idx = 0; idx < length; idx++) {
        [result appendFormat: @"%02x", bytes[idx]];
    }
    return result;
}
@end


@implementation NSData (Base64)


+ (NSData *)dataFromBase64String:(NSString *)aString {
    // initWithBase64EncodedString is available in iOS 7.
    return [[NSData alloc] initWithBase64EncodedString:aString options:0];
}


- (NSString *)base64EncodedString {
    // base64EncodedStringWithOptions is present from iOS 7 onwards.
    return [self base64EncodedStringWithOptions:0];
}


- (NSData *)base64EncodedData {
    // base64EncodedDataWithOptions is present from iOS 7 onwards.
    return [self base64EncodedDataWithOptions:0];
}



-(NSString*)base64urlEncodedString {
    return [[[[self base64EncodedString]
              stringByReplacingOccurrencesOfString:@"+" withString:@"-"]
             stringByReplacingOccurrencesOfString:@"/" withString:@"_"]
            stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

-(NSUUID *)uuidFromData
{
    const void * bytes = self.bytes;
    return bytes == NULL ? nil : [[NSUUID alloc] initWithUUIDBytes:bytes];
}

@end

@implementation NSString (Base64)

- (NSData *)base64urlDecodedString {
    NSString *str = [[self
                      stringByReplacingOccurrencesOfString:@"-" withString:@"+"]
                     stringByReplacingOccurrencesOfString:@"_" withString:@"/"];

    switch (str.length % 4) {
        case 3:
            str = [str stringByAppendingString:@"="];
            break;
        case 2:
            str = [str stringByAppendingString:@"=="];
            break;
        case 1:
            str = [str stringByAppendingString:@"==="];
            break;
            
        default:
            break;
    }

    return [NSData dataFromBase64String:str];
}

- (NSUUID *)uuidFromBase64urlEncodedString {
    NSData *data = [self base64urlDecodedString];
    NSUUID *uuid = [data uuidFromData];
    return uuid;
}

@end
