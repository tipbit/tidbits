//
//  RangeDictionaryTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/4/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "RangeDictionary.h"

#import "TBTestCaseBase.h"

NS_ASSUME_NONNULL_BEGIN


@interface RangeDictionaryTests : TBTestCaseBase

@end


@implementation RangeDictionaryTests


static NSComparator Comparator;

+(void)initialize {
    Comparator = ^NSComparisonResult(NSString * obj1, NSString * obj2) {
        return [obj1 compare:obj2];
    };
}


-(void)testEmpty {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];

    XCTAssertNil(d[@"A"]);
}


-(void)testBadInsert {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    XCTAssertThrowsSpecificNamed([d setObject:@1 from:@"D" to:@"B"], NSException, NSInternalInconsistencyException);
    XCTAssertThrowsSpecificNamed([d setObject:@1 from:@"B" to:@"B"], NSException, NSInternalInconsistencyException);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    XCTAssertThrowsSpecificNamed([d setObject:nil from:@"B" to:@"B"], NSException, NSInternalInconsistencyException);
    XCTAssertThrowsSpecificNamed([d setObject:@1 from:nil to:@"B"], NSException, NSInternalInconsistencyException);
    XCTAssertThrowsSpecificNamed([d setObject:@1 from:@"B" to:nil], NSException, NSInternalInconsistencyException);
#pragma clang diagnostic pop
}


-(void)testInsert1 {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"B" to:@"D"];

    XCTAssertNil(d[@""]);
    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"B"], @1);
    XCTAssertEqualObjects(d[@"C"], @1);
    XCTAssertEqualObjects(d[@"D"], @1);
    XCTAssertNil(d[@"E"]);
    XCTAssertNil(d[@"z"]);
}


-(void)testInsertDisjoint {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"B" to:@"D"];
    [d setObject:@2 from:@"F" to:@"G"];

    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"B"], @1);
    XCTAssertEqualObjects(d[@"C"], @1);
    XCTAssertEqualObjects(d[@"D"], @1);
    XCTAssertNil(d[@"E"]);
    XCTAssertEqualObjects(d[@"F"], @2);
    XCTAssertEqualObjects(d[@"G"], @2);
    XCTAssertNil(d[@"H"]);
}


-(void)testInsertDisjointReordered {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"F" to:@"G"];
    [d setObject:@2 from:@"B" to:@"D"];

    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"B"], @2);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"Cz"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertNil(d[@"Da"]);
    XCTAssertNil(d[@"E"]);
    XCTAssertNil(d[@"Ez"]);
    XCTAssertEqualObjects(d[@"F"], @1);
    XCTAssertEqualObjects(d[@"G"], @1);
    XCTAssertNil(d[@"Ga"]);
    XCTAssertNil(d[@"H"]);
}


-(void)testInsertOverlap {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"B" to:@"D"];
    [d setObject:@2 from:@"C" to:@"E"];

    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"B"], @1);
    XCTAssertEqualObjects(d[@"Bz"], @1);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"E"], @2);
    XCTAssertNil(d[@"Ea"]);
}


-(void)testInsertOverwrite {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"B" to:@"D"];
    [d setObject:@2 from:@"B" to:@"D"];

    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"B"], @2);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertNil(d[@"E"]);
}


-(void)testInsertOverlapBeginning {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"B" to:@"D"];
    [d setObject:@2 from:@"B" to:@"C"];

    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"B"], @2);
    XCTAssertEqualObjects(d[@"Bz"], @2);
    XCTAssertEqualObjects(d[@"C"], @1);  // Note second insert acts like [B, C) so this is correct.
    XCTAssertEqualObjects(d[@"D"], @1);
    XCTAssertNil(d[@"E"]);
}


-(void)testInsertOverlapEnd {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"B" to:@"D"];
    [d setObject:@2 from:@"C" to:@"D"];

    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"B"], @1);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertNil(d[@"E"]);
}


-(void)testInsertForceDisappear {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"B" to:@"C"];
    [d setObject:@2 from:@"C" to:@"E"];
    [d setObject:@3 from:@"E" to:@"F"];

    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"B"], @1);
    XCTAssertEqualObjects(d[@"Bz"], @1);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"Dz"], @2);
    XCTAssertEqualObjects(d[@"E"], @3);
    XCTAssertEqualObjects(d[@"F"], @3);
    XCTAssertNil(d[@"G"]);

    [d setObject:@4 from:@"D" to:@"E"];
    [d setObject:@5 from:@"C" to:@"D"];

    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"B"], @1);
    XCTAssertEqualObjects(d[@"Bz"], @1);
    XCTAssertEqualObjects(d[@"C"], @5);
    XCTAssertEqualObjects(d[@"Cz"], @5);
    XCTAssertEqualObjects(d[@"D"], @4);
    XCTAssertEqualObjects(d[@"Dz"], @4);
    XCTAssertEqualObjects(d[@"E"], @3);  // Note @4 acts like [D, E) so this is correct.
    XCTAssertEqualObjects(d[@"F"], @3);
    XCTAssertNil(d[@"G"]);
}


-(void)testRemoveAllObjects {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"B" to:@"D"];
    [d setObject:@2 from:@"C" to:@"D"];
    [d removeAllObjects];

    XCTAssertNil(d[@"A"]);
    XCTAssertNil(d[@"B"]);
    XCTAssertNil(d[@"C"]);
    XCTAssertNil(d[@"D"]);
    XCTAssertNil(d[@"E"]);
}


@end


NS_ASSUME_NONNULL_END
