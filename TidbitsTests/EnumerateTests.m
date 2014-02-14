//
//  EnumerateTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 2/14/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "Enumerate.h"

#import "TBTestCaseBase.h"


@interface EnumerateTests : TBTestCaseBase

@end


@implementation EnumerateTests


-(void)testEnumerate {
    NSArray* a1 = @[@1, @2, @3];
    NSArray* a2 = @[@4, @5, @6];
    NSMutableArray* result = [NSMutableArray array];
    NSArray* expected = @[@5, @7, @9];

    [Enumerate pairwiseOver:a1 and:a2 usingBlock:^(id obj1, id obj2) {
        [result addObject:@([obj1 intValue] + [obj2 intValue])];
    }];

    XCTAssertEqualObjects(result, expected);
}


-(void)testEnumerateDifferentLengths {
    NSArray* a1 = @[@1, @2];
    NSArray* a2 = @[@4, @5, @6];
    NSMutableArray* result = [NSMutableArray array];
    NSArray* expected = @[@5, @7];

    [Enumerate pairwiseOver:a1 and:a2 usingBlock:^(id obj1, id obj2) {
        [result addObject:@([obj1 intValue] + [obj2 intValue])];
    }];

    XCTAssertEqualObjects(result, expected);
}


-(void)testEnumerateNil {
    NSArray* a1 = nil;
    NSArray* a2 = @[@4, @5, @6];
    NSMutableArray* result = [NSMutableArray array];
    NSArray* expected = @[];

    [Enumerate pairwiseOver:a1 and:a2 usingBlock:^(id obj1, id obj2) {
        [result addObject:@([obj1 intValue] + [obj2 intValue])];
    }];

    XCTAssertEqualObjects(result, expected);
}


@end
