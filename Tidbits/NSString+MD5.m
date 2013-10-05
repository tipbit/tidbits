//
//  NSString+MD5.m
//  Tidbits
//
//  Created by Ewan Mellor on 10/4/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "NSString+MD5.h"


@implementation NSString (MD5)


-(NSUUID*)md5uuid {
    const char *utf8 = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(utf8, strlen(utf8), digest);
    return [[NSUUID alloc] initWithUUIDBytes:digest];
}


@end
