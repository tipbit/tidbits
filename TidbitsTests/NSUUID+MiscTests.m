//
//  NSUUID+MiscTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 2/7/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "TBTestCaseBase.h"

#import "NSUUID+Misc.h"


@interface NSUUID_MiscTests : TBTestCaseBase

@end


@implementation NSUUID_MiscTests


-(void)testUUIDStringBase64url {
    NSUUID* input = [[NSUUID alloc] initWithUUIDString:@"5F62567A-74C2-4D32-B649-D26D762433BF"];
    NSString* expected = @"X2JWenTCTTK2SdJtdiQzvw";
    NSString* result = [input UUIDStringBase64url];
    XCTAssertEqualObjects(result, expected);
}


-(void)testUUIDStringBase64urlDashUnderscore {
    NSUUID* input = [[NSUUID alloc] initWithUUIDString:@"2e1336fd-4349-485f-8bad-df45b92ae32e"];
    NSString* expected = @"LhM2_UNJSF-Lrd9FuSrjLg";
    NSString* result = [input UUIDStringBase64url];
    XCTAssertEqualObjects(result, expected);
}


-(void)testUUIDFromBase64urlString {
    NSString * input = @"X2JWenTCTTK2SdJtdiQzvw";
    NSUUID * expected = [[NSUUID alloc] initWithUUIDString:@"5F62567A-74C2-4D32-B649-D26D762433BF"];
    NSUUID * result = [NSUUID UUIDFromBase64urlString:input];
    XCTAssertEqualObjects(result, expected);
}


-(void)testUUIDFromBase64urlStringDashUnderscore {
    NSString * input = @"LhM2_UNJSF-Lrd9FuSrjLg";
    NSUUID * expected = [[NSUUID alloc] initWithUUIDString:@"2e1336fd-4349-485f-8bad-df45b92ae32e"];
    NSUUID * result = [NSUUID UUIDFromBase64urlString:input];
    XCTAssertEqualObjects(result, expected);
}


@end
