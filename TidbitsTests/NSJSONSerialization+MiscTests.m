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


-(void)testJSONObjectFromBundle {
    NSError * err = nil;
    id result = [NSJSONSerialization JSONObjectFromBundle:[NSBundle bundleForClass:self.class] resourceName:@"NSJSONSerialization+MiscTests" error:&err];
    XCTAssert([result isKindOfClass:[NSDictionary class]]);
    XCTAssertNil(err);
    NSDictionary * resultDict = (NSDictionary *)result;
    XCTAssertEqual(resultDict.count, 1U);
    XCTAssertEqualStrings(resultDict[@"key1"], @"val1");
}


-(void)testJSONObjectFromBundleAsync {
    __block id result = nil;
    __block NSError * error = nil;
    WaitForTimeoutAsync(2.0, ^(bool *done) {
        [NSJSONSerialization JSONObjectFromBundleAsync:[NSBundle bundleForClass:self.class] resourceName:@"NSJSONSerialization+MiscTests" onSuccess:^(id obj) {
            result = obj;
            *done = YES;
        } onFailure:^(NSError * err) {
            error = err;
            *done = YES;
        }];
    });

    XCTAssert([result isKindOfClass:[NSDictionary class]]);
    XCTAssertNil(error);
    NSDictionary * resultDict = (NSDictionary *)result;
    XCTAssertEqual(resultDict.count, 1U);
    XCTAssertEqualStrings(resultDict[@"key1"], @"val1");
}


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
