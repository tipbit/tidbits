//
//  NSData+FooTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 2/8/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "TBTestCaseBase.h"

#import "NSData+Base64.h"
#import "NSData+MD5.h"
#import "NSData+SHA256.h"


@interface NSData_FooTests : TBTestCaseBase

@end


@implementation NSData_FooTests


-(void)testSha256Md5 {
    NSData* input = [NSData dataWithBytes:[@"asdfghjkl" UTF8String] length:9];
    NSString* expected_sha = @"5c80565db6f29da0b01aa12522c37b32f121cbe47a861ef7f006cb22922dffa1";
    NSString* expected_md5 = @"c44a471bd78cc6c2fea32b9fe028d30a";
    XCTAssertEqualObjects([input sha256], expected_sha);
    XCTAssertEqualObjects([input md5], expected_md5);
}


-(void)testSha256Md5Empty {
    NSData* input = [NSData data];
    NSString* expected_sha = @"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
    NSString* expected_md5 = @"d41d8cd98f00b204e9800998ecf8427e";
    XCTAssertEqualObjects([input sha256], expected_sha);
    XCTAssertEqualObjects([input md5], expected_md5);
}


-(void)testSha256Data {
    NSData* input = [NSData dataWithBytes:[@"asdfghjkl" UTF8String] length:9];
    NSString* expected_sha_str = @"5c80565db6f29da0b01aa12522c37b32f121cbe47a861ef7f006cb22922dffa1";
    NSString* expected_md5_str = @"c44a471bd78cc6c2fea32b9fe028d30a";
    NSData* expected_sha = [NSData dataFromHexidecimal:expected_sha_str];
    NSData* expected_md5 = [NSData dataFromHexidecimal:expected_md5_str];
    XCTAssertEqualObjects([input sha256Data], expected_sha);
    XCTAssertEqualObjects([input md5Data], expected_md5);
}


-(void)testSha256DataEmpty {
    NSData* input = [NSData data];
    NSString* expected_sha_str = @"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
    NSString* expected_md5_str = @"d41d8cd98f00b204e9800998ecf8427e";
    NSData* expected_sha = [NSData dataFromHexidecimal:expected_sha_str];
    NSData* expected_md5 = [NSData dataFromHexidecimal:expected_md5_str];
    XCTAssertEqualObjects([input sha256Data], expected_sha);
    XCTAssertEqualObjects([input md5Data], expected_md5);
}


@end
