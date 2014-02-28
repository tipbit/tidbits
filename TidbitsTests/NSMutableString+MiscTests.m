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


@end
