//
//  NSDictionary+MapTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 2/8/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "TBTestCaseBase.h"

#import "NSDictionary+Map.h"


@interface NSDictionary_MapTests : TBTestCaseBase

@end


@implementation NSDictionary_MapTests


-(void)testMap {
    NSDictionary* input = @{@1: @2, @2: @3, @3: @4};
    NSArray* expected = @[@3, @5];
    NSArray* result = [input map:^id(id key, id val) {
        int k = [key intValue];
        int v = [val intValue];
        return k == 3 ? nil : @(k + v);
    }];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wselector"  // Silence warning about use of compare: below.
    XCTAssertEqualObjects([result sortedArrayUsingSelector:@selector(compare:)], expected);
#pragma clang diagnostic pop
}


-(void)testMapEmpty {
    NSDictionary* input = @{};
    NSArray* expected = @[];
    NSArray* result = [input map:^id(id key, id val) {
        int k = [key intValue];
        int v = [val intValue];
        return k == 3 ? nil : @(k + v);
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testMapResultEmpty {
    NSDictionary* input = @{@1: @2, @2: @3, @3: @4};
    NSArray* expected = @[];
    NSArray* result = [input map:^id(id key, id val) {
        return nil;
    }];
    XCTAssertEqualObjects(result, expected);
}


@end
