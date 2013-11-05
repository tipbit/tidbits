//
//  NSArray+MapTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 10/9/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "TBTestCaseBase.h"

#import "NSArray+Map.h"


@interface NSArray_MapTests : TBTestCaseBase

@end


@implementation NSArray_MapTests


- (void)testFilterAll
{
    NSArray* input = @[@1, @2, @3, @4, @5, @6];
    NSArray* expected = @[@1, @2, @3, @4, @5, @6];
    NSArray* result = [input filter:^bool(id obj) {
        return true;
    }];

    XCTAssertEqualObjects(result, expected);
}


- (void)testFilterNearSameSize
{
    NSArray* input = @[@1, @2, @3, @4, @5, @6];
    NSArray* expected = @[@1, @2, @3, @4, @6];
    NSArray* result = [input filter:^bool(id obj) {
        return [obj intValue] != 5;
    }];

    XCTAssertEqualObjects(result, expected);
}


- (void)testFilterMuchSmaller
{
    NSArray* input = @[@1, @2, @3, @4, @5, @6];
    NSArray* expected = @[@3];
    NSArray* result = [input filter:^bool(id obj) {
        return [obj intValue] == 3;
    }];

    XCTAssertEqualObjects(result, expected);
}


- (void)testFilterEmpty
{
    NSArray* input = @[@1, @2, @3, @4, @5, @6];
    NSArray* expected = @[];
    NSArray* result = [input filter:^bool(id obj) {
        return false;
    }];

    XCTAssertEqualObjects(result, expected);
}


@end
