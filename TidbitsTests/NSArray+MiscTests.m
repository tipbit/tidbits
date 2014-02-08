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


-(void)testDictAtIndex {
    NSDictionary* dict = @{@1: @2};
    NSArray* input = @[@0, dict, @1];

    XCTAssertEqualObjects([input dictAtIndex:0], nil);
    XCTAssertEqualObjects([input dictAtIndex:1], dict);
    XCTAssertEqualObjects([input dictAtIndex:2], nil);
    XCTAssertEqualObjects([input dictAtIndex:3], nil);
}


-(void)testObjectAtIndexWithDefault {
    NSDictionary* dict = @{@1: @2};
    NSArray* input = @[@0, dict, @1];

    XCTAssertEqualObjects([input objectAtIndex:0 withDefault:@6], @0);
    XCTAssertEqualObjects([input objectAtIndex:1 withDefault:@42], dict);
    XCTAssertEqualObjects([input objectAtIndex:2 withDefault:nil], @1);
    XCTAssertEqualObjects([input objectAtIndex:3 withDefault:@7], @7);
    XCTAssertEqualObjects([input objectAtIndex:4 withDefault:nil], nil);
    XCTAssertEqualObjects([input objectAtIndex:NSNotFound withDefault:@7], @7);
}


-(void)testArrayWithEnumerationFromArray {
    NSArray* input = @[@0, @1];
    XCTAssertEqualObjects([NSArray arrayWithEnumeration:input], input);
}


-(void)testArrayWithEnumerationEmpty {
    NSArray* input = @[];
    XCTAssertEqualObjects([NSArray arrayWithEnumeration:input], input);
}


@end
