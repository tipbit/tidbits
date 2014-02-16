//
//  NSMutableArray+ExtTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 2/15/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSMutableArray+Ext.h"

#import "TBTestCaseBase.h"


@interface NSMutableArray_ExtTests : TBTestCaseBase

@end


@implementation NSMutableArray_ExtTests


- (void)testRemoveDuplicatesSimple {
    [self doTestRemoveDuplicates:@[@1, @2, @2, @3, @1] expected:@[@1, @2, @3]];
}


- (void)testRemoveDuplicatesEmpty {
    [self doTestRemoveDuplicates:@[] expected:@[]];
}


- (void)testRemoveDuplicatesNoDuplicates {
    [self doTestRemoveDuplicates:@[@2, @3, @1] expected:@[@2, @3, @1]];
}


-(void)doTestRemoveDuplicates:(NSArray*)input expected:(NSArray*)expected {
    NSMutableArray* arr = [NSMutableArray arrayWithArray:input];
    [arr removeDuplicates];
    XCTAssertEqualObjects([NSArray arrayWithArray:arr], expected);
}


@end
