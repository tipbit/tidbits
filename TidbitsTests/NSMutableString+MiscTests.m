//
//  NSMutableString+MiscTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 2/28/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSMutableString+Misc.h"

#import "TBTestCaseBase.h"


@interface NSMutableString_MiscTests : TBTestCaseBase

@end


@implementation NSMutableString_MiscTests


-(void)testAppendString {
    NSMutableString* input = [NSMutableString string];
    [input appendStringOrNil:@"A"];
    [input appendStringOrNil:nil];
    [input appendStringOrNil:@"B"];
    XCTAssertEqualObjects(input, @"AB");
}


-(void)testReplaceAllNormal {
    NSMutableString * input = [NSMutableString stringWithString:@"This [[A]] has [[B]]"];
    [input replaceAll:@{@"[[A]]": @"test",
                        @"[[B]]": @"passed"}];
    XCTAssertEqualObjects(input, @"This test has passed");
}


-(void)testReplaceAllNil {
    NSMutableString * input = [NSMutableString stringWithString:@"This [[A]] has [[B]]"];
    [input replaceAll:nil];
    XCTAssertEqualObjects(input, @"This [[A]] has [[B]]");
}


-(void)testReplaceAllBlank {
    NSMutableString * input = [NSMutableString stringWithString:@"This [[A]] has [[B]]"];
    [input replaceAll:@{}];
    XCTAssertEqualObjects(input, @"This [[A]] has [[B]]");
}


-(void)testReplaceAllNoHits {
    NSMutableString * input = [NSMutableString stringWithString:@"This [[A]] has [[B]]"];
    [input replaceAll:@{@"[[C]]": @"test",
                        @"[[D]]": @"failed"}];
    XCTAssertEqualObjects(input, @"This [[A]] has [[B]]");
}


@end
