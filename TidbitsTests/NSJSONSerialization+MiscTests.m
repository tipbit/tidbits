//
//  NSJSONSerialization+MiscTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 4/27/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSJSONSerialization+Misc.h"

#import "TBTestCaseBase.h"


@interface NSJSONSerializationMiscTests : TBTestCaseBase

@end


@implementation NSJSONSerializationMiscTests


-(void)testStringWithJSONObject {
    NSDictionary* input = @{@"foo": @"bar \u2013 baz"};
    NSString* expectedPlain = @"{\"foo\":\"bar \u2013 baz\"}";
    NSString* expectedPretty = @"{\n  \"foo\" : \"bar \u2013 baz\"\n}";

    NSError* err = nil;
    XCTAssertEqualStrings([NSJSONSerialization stringWithJSONObject:input error:&err], expectedPlain);
    XCTAssertNil(err);
    XCTAssertEqualStrings([NSJSONSerialization stringWithJSONObject:input options:0 error:&err], expectedPlain);
    XCTAssertNil(err);
    XCTAssertEqualStrings([NSJSONSerialization stringWithJSONObject:input options:NSJSONWritingPrettyPrinted error:&err], expectedPretty);
    XCTAssertNil(err);
}


@end
