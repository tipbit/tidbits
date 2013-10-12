//
//  NSData+SHA256.m
//  Tidbits
//
//  Created by Ewan Mellor on 10/11/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "NSData+SHA256.h"

@implementation NSData (SHA256)

-(NSString*)sha256 {
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, self.length, digest);

    return [NSString stringWithFormat:(@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x"
                                       @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x"),
            digest[0],  digest[1],  digest[2],  digest[3],
            digest[4],  digest[5],  digest[6],  digest[7],
            digest[8],  digest[9],  digest[10], digest[11],
            digest[12], digest[13], digest[14], digest[15],
            digest[16], digest[17], digest[18], digest[19],
            digest[20], digest[21], digest[22], digest[23],
            digest[24], digest[25], digest[26], digest[27],
            digest[28], digest[29], digest[30], digest[31]];
}

-(NSData*)sha256Data {
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, self.length, digest);

    NSData *result = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    return result;
}

@end
