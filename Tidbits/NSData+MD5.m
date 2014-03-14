//
//  NSData+MD5.m
//  Tidbits
//
//  Created by Ewan Mellor on 7/3/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "NSData+MD5.h"

@implementation NSData (MD5)

-(NSString*)md5 {
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, digest);

    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            digest[0],  digest[1],  digest[2],  digest[3],
            digest[4],  digest[5],  digest[6],  digest[7],
            digest[8],  digest[9],  digest[10], digest[11],
            digest[12], digest[13], digest[14], digest[15]];
}

-(NSData*)md5Data {
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, digest);

    NSData *result = [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    return result;
}

@end
