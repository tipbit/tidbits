//
//  NSFileHandle+MD5.m
//  Tidbits
//
//  Created by Ewan Mellor on 6/29/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "NSFileHandle+MD5.h"


@implementation NSFileHandle (MD5)


- (NSString*) md5 {
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);

    while (true) {
        @autoreleasepool {
            NSData* d = [self readDataOfLength:4096];

            if (d.length == 0)
                break;

            CC_MD5_Update(&md5, d.bytes, d.length);
        }
    }

    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);

    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            digest[0],  digest[1],  digest[2],  digest[3],
            digest[4],  digest[5],  digest[6],  digest[7],
            digest[8],  digest[9],  digest[10], digest[11],
            digest[12], digest[13], digest[14], digest[15]];
}


@end
