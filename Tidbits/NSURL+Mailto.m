//
//  NSURL+Mailto.m
//  Tidbits
//
//  Created by Ewan Mellor on 2/2/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "GTMNSDictionary+URLArguments.h"
#import "NSArray+Map.h"
#import "NSStringPunycodeAdditions.h"

#import "NSURL+Mailto.h"


@implementation NSURL (Mailto)


-(void)parseMailtoReturningTo:(NSArray * __autoreleasing *)resultTo subject:(NSString * __autoreleasing *)resultSubject body:(NSString * __autoreleasing *)resultBody {
    NSString * rs = self.resourceSpecifier;
    NSArray * rs_bits = [rs componentsSeparatedByString:@"?"];
    // Note that there may have been two question marks in rs.  This is illegal per RFC 6068.
    // We are just discarding anything after the illegal question mark.

    NSString * to_bit = rs_bits[0];
    NSArray * to = to_bit.length > 0 ? [to_bit componentsSeparatedByString:@","] : nil;
    to = [to map:^id(id obj) {
        return decodeEncodeAddress(obj);
    }];

    NSDictionary * hfields = rs_bits.count > 1 ? [NSDictionary gtm_dictionaryWithHttpArgumentsString:rs_bits[1]] : nil;

    if (resultTo != NULL) {
        *resultTo = to;
    }
    if (resultSubject != NULL) {
        *resultSubject = hfields[@"subject"];
    }
    if (resultBody != NULL) {
        *resultBody = hfields[@"body"];
    }
}


static NSString * decodeEncodeAddress(NSString * addr) {
    NSArray * addrBits = [addr componentsSeparatedByString:@"@"];
    if (addrBits.count != 2) {
        return addr;
    }
    NSString * utf8Name = [addrBits[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * utf8Domain = [addrBits[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * punyName = [utf8Name IDNAEncodedString];
    NSString * punyDomain = [utf8Domain IDNAEncodedString];
    return [NSString stringWithFormat:@"%@@%@", punyName, punyDomain];
}


@end
