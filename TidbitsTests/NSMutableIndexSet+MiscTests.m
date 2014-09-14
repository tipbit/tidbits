//
//  NSMutableIndexSet+MiscTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 9/14/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSMutableIndexSet+Misc.h"

#import "TBTestCaseBase.h"


@interface NSMutableIndexSet_MiscTests : TBTestCaseBase

@end


@implementation NSMutableIndexSet_MiscTests


-(void)testRemoveFirstN0 {
    NSMutableIndexSet * input = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)];
    NSMutableIndexSet * expectedInput = [input mutableCopy];
    NSMutableIndexSet * expectedResult = [NSMutableIndexSet indexSet];

    NSMutableIndexSet * result = [input removeFirstN:0];
    [self assert:input result:result expectedInput:expectedInput expectedResult:expectedResult];
}


-(void)testRemoveFirstN2 {
    NSMutableIndexSet * input = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)];
    NSMutableIndexSet * expectedInput = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 3)];
    NSMutableIndexSet * expectedResult = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)];

    NSMutableIndexSet * result = [input removeFirstN:2];
    [self assert:input result:result expectedInput:expectedInput expectedResult:expectedResult];
}


-(void)testRemoveFirstNAll {
    NSMutableIndexSet * input = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)];
    NSMutableIndexSet * expectedInput = [NSMutableIndexSet indexSet];
    NSMutableIndexSet * expectedResult = [input mutableCopy];

    NSMutableIndexSet * result = [input removeFirstN:5];
    [self assert:input result:result expectedInput:expectedInput expectedResult:expectedResult];
}


-(void)testRemoveFirstNMoreThanAll {
    NSMutableIndexSet * input = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)];
    NSMutableIndexSet * expectedInput = [NSMutableIndexSet indexSet];
    NSMutableIndexSet * expectedResult = [input mutableCopy];

    NSMutableIndexSet * result = [input removeFirstN:10];
    [self assert:input result:result expectedInput:expectedInput expectedResult:expectedResult];
}


-(void)testRemoveFirstNSplitRanges {
    NSMutableIndexSet * input = [NSMutableIndexSet indexSet];
    [input addIndexesInRange:NSMakeRange(0, 5)];
    [input addIndexesInRange:NSMakeRange(10, 10)];
    NSMutableIndexSet * expectedInput = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(12, 8)];
    NSMutableIndexSet * expectedResult = [NSMutableIndexSet indexSet];
    [expectedResult addIndexesInRange:NSMakeRange(0, 5)];
    [expectedResult addIndexesInRange:NSMakeRange(10, 2)];

    NSMutableIndexSet * result = [input removeFirstN:7];
    [self assert:input result:result expectedInput:expectedInput expectedResult:expectedResult];
}


-(void)testRemoveFirstNBetweenRanges {
    NSMutableIndexSet * input = [NSMutableIndexSet indexSet];
    [input addIndexesInRange:NSMakeRange(0, 5)];
    [input addIndexesInRange:NSMakeRange(10, 10)];
    NSMutableIndexSet * expectedInput = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(10, 10)];
    NSMutableIndexSet * expectedResult = [NSMutableIndexSet indexSet];
    [expectedResult addIndexesInRange:NSMakeRange(0, 5)];

    NSMutableIndexSet * result = [input removeFirstN:5];
    [self assert:input result:result expectedInput:expectedInput expectedResult:expectedResult];
}


-(void)assert:(NSMutableIndexSet *)input result:(NSMutableIndexSet *)result expectedInput:(NSMutableIndexSet *)expectedInput expectedResult:(NSMutableIndexSet *)expectedResult {
    XCTAssertNotNil(input);
    XCTAssertNotNil(result);
    XCTAssertNotNil(expectedInput);
    XCTAssertNotNil(expectedResult);
    XCTAssertEqualObjects(input, expectedInput);
    XCTAssertEqualObjects(result, expectedResult);
}


@end
