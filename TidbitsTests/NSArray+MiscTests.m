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


@end
