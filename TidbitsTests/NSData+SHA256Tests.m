//
//  NSData+SHA256Tests.m
//  Tidbits
//
//  Created by Ewan Mellor on 2/8/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "TBTestCaseBase.h"

#import "NSData+Base64.h"
#import "NSData+SHA256.h"


@interface NSData_SHA256Tests : TBTestCaseBase

@end


@implementation NSData_SHA256Tests


-(void)testSha256 {
    NSData* input = [NSData dataWithBytes:[@"asdfghjkl" UTF8String] length:9];
    NSString* expected = @"5c80565db6f29da0b01aa12522c37b32f121cbe47a861ef7f006cb22922dffa1";
    XCTAssertEqualObjects([input sha256], expected);
}


-(void)testSha256Empty {
    NSData* input = [NSData data];
    NSString* expected = @"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
    XCTAssertEqualObjects([input sha256], expected);
}


-(void)testSha256Data {
    NSData* input = [NSData dataWithBytes:[@"asdfghjkl" UTF8String] length:9];
    NSString* expectedStr = @"5c80565db6f29da0b01aa12522c37b32f121cbe47a861ef7f006cb22922dffa1";
    NSData* expected = [NSData dataFromHexidecimal:expectedStr];
    XCTAssertEqualObjects([input sha256Data], expected);
}


-(void)testSha256DataEmpty {
    NSData* input = [NSData data];
    NSString* expectedStr = @"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
    NSData* expected = [NSData dataFromHexidecimal:expectedStr];
    XCTAssertEqualObjects([input sha256Data], expected);
}


@end
