//
//  NSArray+MiscTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 10/26/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "TBTestCaseBase.h"

#import "NSArray+Misc.h"


@interface NSArray_MiscTests : TBTestCaseBase

@end


@implementation NSArray_MiscTests


-(void)testComponentsJoinedByStringEmpty {
    XCTAssertEqualObjects(@[], [@[] componentsJoinedByString:@"," inBatches:3]);
}


-(void)testComponentsJoinedByStringBatches {
    NSArray* input = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G"];
    NSArray* expected = @[@"A,B,C", @"D,E,F", @"G"];

    XCTAssertEqualObjects(expected, [input componentsJoinedByString:@"," inBatches:3]);
}


-(void)testComponentsJoinedByStringOneBatch {
    NSArray* input = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G"];
    NSArray* expected = @[@"A,B,C,D,E,F,G"];

    XCTAssertEqualObjects(expected, [input componentsJoinedByString:@"," inBatches:30]);
}


-(void)testFilteredArrayUsingBlock {
    NSArray* input = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G"];
    NSArray* expected = @[@"A", @"B", @"D", @"E", @"F", @"G"];

    XCTAssertEqualObjects(expected, [input filteredArrayUsingBlock:^bool(id obj) {
        return ![obj isEqualToString:@"C"];
    }]);
}


-(void)testFilteredArrayUsingBlockNone {
    NSArray* input = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G"];
    NSArray* expected = @[];

    XCTAssertEqualObjects(expected, [input filteredArrayUsingBlock:^bool(id obj) {
        return false;
    }]);
}


-(void)testFilteredArrayUsingBlockAll {
    NSArray* input = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G"];

    XCTAssertEqualObjects(input, [input filteredArrayUsingBlock:^bool(id obj) {
        return true;
    }]);
}


@end
