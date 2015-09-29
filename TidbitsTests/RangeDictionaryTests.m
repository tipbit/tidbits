//
//  RangeDictionaryTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/4/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "RangeDictionary.h"

#import "TBTestCaseBase.h"
#import "NSDate+ISO8601.h"
#import "NSDate+Ext.h"

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
    XCTAssertEqual(d.rangeCount, 0U);
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
    XCTAssertEqual(d.rangeCount, 0U);
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
    XCTAssertEqual(d.rangeCount, 1U);
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
    XCTAssertEqual(d.rangeCount, 2U);
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
    XCTAssertEqual(d.rangeCount, 2U);
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
    XCTAssertEqual(d.rangeCount, 2U);
}


-(void)testInsertOverlapBottom {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"C" to:@"G"];
    [d setObject:@2 from:@"F" to:@"G"];
    [d setObject:@3 from:@"E" to:@"F"];
    [d setObject:@4 from:@"B" to:@"D"];

    XCTAssertNil(d[@"A"]);
    XCTAssertNil(d[@"Az"]);
    XCTAssertEqualObjects(d[@"B"], @4);
    XCTAssertEqualObjects(d[@"C"], @4);
    XCTAssertEqualObjects(d[@"D"], @1);
    XCTAssertEqualObjects(d[@"E"], @3);
    XCTAssertEqualObjects(d[@"F"], @2);
    XCTAssertEqualObjects(d[@"G"], @2);
    XCTAssertNil(d[@"Ga"]);
    XCTAssertEqual(d.rangeCount, 4U);
}


-(void)testInsertOverlapEntirely {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"C" to:@"D"];
    [d setObject:@2 from:@"B" to:@"E"];

    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"B"], @2);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"E"], @2);
    XCTAssertNil(d[@"Ea"]);
    XCTAssertNil(d[@"F"]);
    XCTAssertEqual(d.rangeCount, 1U);
}


-(void)testInsertOverlapDates {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:NSDate.dateComparatorMsecPrecision];
    [d setObject:[NSDate dateFromIso8601:@"1971-01-01T00:00:00.000Z"] from:[NSDate dateFromIso8601:@"1971-01-01T00:00:00.000Z"] to:[NSDate dateFromIso8601:@"2015-06-26T21:47:08.895Z"]];
    [d setObject:[NSDate dateFromIso8601:@"2015-08-21T23:40:43.760Z"] from:[NSDate dateFromIso8601:@"2015-06-26T21:47:08.895Z"] to:[NSDate dateFromIso8601:@"2015-08-21T23:40:00.000Z"]];
    [d setObject:[NSDate dateFromIso8601:@"2015-08-21T23:50:27.828Z"] from:[NSDate dateFromIso8601:@"2015-08-21T23:40:00.000Z"] to:[NSDate dateFromIso8601:@"2015-08-21T23:50:27.828Z"]];
    [d setObject:[NSDate dateFromIso8601:@"2015-08-21T23:40:15.633Z"] from:[NSDate dateFromIso8601:@"2015-08-21T23:40:43.760Z"] to:[NSDate dateFromIso8601:@"2015-08-21T23:40:59.999Z"]];

    XCTAssertEqual(d.rangeCount, 5U);

    RangeDictionary * d1 = [[RangeDictionary alloc] initWithComparator:NSDate.dateComparatorMsecPrecision];
    [d1 setObject:[NSDate dateFromIso8601:@"1971-01-01T00:00:00.000Z"] from:[NSDate dateFromIso8601:@"1971-01-01T00:00:00.000Z"] to:[NSDate dateFromIso8601:@"2015-06-26T21:47:08.895Z"]];
    [d1 setObject:[NSDate dateFromIso8601:@"2015-08-21T23:40:43.760Z"] from:[NSDate dateFromIso8601:@"2015-06-26T21:47:08.895Z"] to:[NSDate dateFromIso8601:@"2015-08-21T23:40:00.000Z"]];
    [d1 setObject:[NSDate dateFromIso8601:@"2015-08-21T23:43:08.480Z"] from:[NSDate dateFromIso8601:@"2015-08-21T23:40:00.000Z"] to:[NSDate dateFromIso8601:@"2015-08-21T23:43:08.480Z"]];
    [d1 setObject:[NSDate dateFromIso8601:@"2015-08-21T23:40:15.633Z"] from:[NSDate dateFromIso8601:@"2015-08-21T23:40:43.760Z"] to:[NSDate dateFromIso8601:@"2015-08-21T23:40:59.999Z"]];

    XCTAssertEqual(d1.rangeCount, 5U);

    //reshuffled inserts
    RangeDictionary * d2 = [[RangeDictionary alloc] initWithComparator:NSDate.dateComparatorMsecPrecision];
    [d2 setObject:[NSDate dateFromIso8601:@"2015-08-21T23:43:08.480Z"] from:[NSDate dateFromIso8601:@"2015-08-21T23:40:00.000Z"] to:[NSDate dateFromIso8601:@"2015-08-21T23:43:08.480Z"]];
    [d2 setObject:[NSDate dateFromIso8601:@"2015-08-21T23:40:15.633Z"] from:[NSDate dateFromIso8601:@"2015-08-21T23:40:43.760Z"] to:[NSDate dateFromIso8601:@"2015-08-21T23:40:59.999Z"]];
    [d2 setObject:[NSDate dateFromIso8601:@"1971-01-01T00:00:00.000Z"] from:[NSDate dateFromIso8601:@"1971-01-01T00:00:00.000Z"] to:[NSDate dateFromIso8601:@"2015-06-26T21:47:08.895Z"]];
    [d2 setObject:[NSDate dateFromIso8601:@"2015-08-21T23:40:43.760Z"] from:[NSDate dateFromIso8601:@"2015-06-26T21:47:08.895Z"] to:[NSDate dateFromIso8601:@"2015-08-21T23:40:00.000Z"]];

    XCTAssertEqual(d2.rangeCount, 5U);

    //reshuffled inserts
    RangeDictionary * d3 = [[RangeDictionary alloc] initWithComparator:NSDate.dateComparatorMsecPrecision];
    [d3 setObject:[NSDate dateFromIso8601:@"2015-08-21T23:43:08.480Z"] from:[NSDate dateFromIso8601:@"2015-08-21T23:40:00.000Z"] to:[NSDate dateFromIso8601:@"2015-08-21T23:43:08.480Z"]];
    [d3 setObject:[NSDate dateFromIso8601:@"2015-08-21T23:40:15.633Z"] from:[NSDate dateFromIso8601:@"2015-08-21T23:40:43.760Z"] to:[NSDate dateFromIso8601:@"2015-08-21T23:40:59.999Z"]];
    [d3 setObject:[NSDate dateFromIso8601:@"2015-08-21T23:40:43.760Z"] from:[NSDate dateFromIso8601:@"2015-06-26T21:47:08.895Z"] to:[NSDate dateFromIso8601:@"2015-08-21T23:40:00.000Z"]];
    [d3 setObject:[NSDate dateFromIso8601:@"1971-01-01T00:00:00.000Z"] from:[NSDate dateFromIso8601:@"1971-01-01T00:00:00.000Z"] to:[NSDate dateFromIso8601:@"2015-06-26T21:47:08.895Z"]];

    XCTAssertEqual(d3.rangeCount, 5U);
    

}

-(void)testInsertOverlapDates2 {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:NSDate.dateComparatorMsecPrecision];
    //Actual scenario that failed
    //Existing entries.
    [d from:[NSDate dateFromIso8601:@"1971-01-01T00:00:00.000Z"] to:[NSDate dateFromIso8601:@"2015-06-26T21:47:08.895Z"] setObject:[NSDate dateFromIso8601:@"1971-01-01T00:00:00.000Z"]];
    [d from:[NSDate dateFromIso8601:@"2015-06-26T21:47:08.895Z"] to:[NSDate dateFromIso8601:@"2015-08-21T23:40:43.760Z"] setObject:[NSDate dateFromIso8601:@"2015-08-21T23:40:43.760Z"]];
    [d from:[NSDate dateFromIso8601:@"2015-08-21T23:40:43.760Z"] to:[NSDate dateFromIso8601:@"2015-08-21T23:40:59.999Z"] setObject:[NSDate dateFromIso8601:@"2015-08-21T23:40:15.633Z"]];

    //Add new entry:
    [d from:[NSDate dateFromIso8601:@"2014-04-23T01:32:45.936Z"] to:[NSDate dateFromIso8601:@"2015-08-22T05:00:33.510Z"] setObject:[NSDate dateFromIso8601:@"2015-08-22T05:00:33.510Z"]];

    //Should give:
    //1971-01-01T00:00:00.000Z - 2014-04-23T01:32:45.936Z = 1971-01-01T00:00:00.000Z
    //2014-04-23T01:32:45.936Z - 2015-08-22T05:00:33.510Z = 2015-08-22T05:00:33.510Z
    XCTAssertEqual(d.rangeCount, 2U);
    XCTAssertEqualObjects(d[[NSDate dateFromIso8601:@"1971-01-01T00:00:00.000Z"]], [NSDate dateFromIso8601:@"1971-01-01T00:00:00.000Z"]);
    XCTAssertEqualObjects(d[[NSDate dateFromIso8601:@"2014-04-23T01:32:45.936Z"]], [NSDate dateFromIso8601:@"2015-08-22T05:00:33.510Z"]);
    XCTAssertEqualObjects(d[[NSDate dateFromIso8601:@"2015-06-26T21:47:08.895Z"]], [NSDate dateFromIso8601:@"2015-08-22T05:00:33.510Z"]);
    XCTAssertEqualObjects(d[[NSDate dateFromIso8601:@"2015-08-21T23:40:43.760Z"]], [NSDate dateFromIso8601:@"2015-08-22T05:00:33.510Z"]);
}

-(void)testAllInsertCombinations{
    NSMutableSet *testCases = [NSMutableSet set];
    NSUInteger testCase = 0;
    NSUInteger ret = 0;
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];

    testCase = 1; //single entry
    [testCases addObject:@(testCase)];
    ret = [d from:@"C" to:@"E" setObject:@1];
    XCTAssertEqual(testCase, ret);
    XCTAssertEqual(d.rangeCount, 1U);
    //(C - E = 1)

    testCase = 2;//duplicate key
    [testCases addObject:@(testCase)];
    ret = [d from:@"C" to:@"E" setObject:@2];
    XCTAssertEqual(testCase, ret);
    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"E"], @2);
    XCTAssertNil(d[@"F"]);
    XCTAssertEqual(d.rangeCount, 1U);
    //(C - E = 2)

    testCase = 7;//add A-B (begining of range)
    [testCases addObject:@(testCase)];
    ret = [d from:@"A" to:@"B" setObject:@3];
    XCTAssertEqual(testCase, ret);
    XCTAssertEqualObjects(d[@"A"], @3);
    XCTAssertEqualObjects(d[@"B"], @3);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"E"], @2);
    XCTAssertNil(d[@"F"]);
    XCTAssertEqual(d.rangeCount, 2U);
    //(A - B = 3, C - E = 2)

    testCase = 16; //Add G-I
    [testCases addObject:@(testCase)];
    ret = [d from:@"G" to:@"I" setObject:@4];
    XCTAssertEqual(testCase, ret);
    XCTAssertEqualObjects(d[@"A"], @3);
    XCTAssertEqualObjects(d[@"B"], @3);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"E"], @2);
    XCTAssertNil(d[@"F"]);
    XCTAssertEqualObjects(d[@"G"], @4);
    XCTAssertEqualObjects(d[@"H"], @4);
    XCTAssertEqualObjects(d[@"I"], @4);
    XCTAssertEqual(d.rangeCount, 3U);
    //(A - B = 3, C - E = 2, G - I = 4)

    testCase = 8; //add F-H
    [testCases addObject:@(testCase)];
    ret = [d from:@"F" to:@"H" setObject:@5];
    XCTAssertEqual(testCase, ret);
    XCTAssertEqualObjects(d[@"A"], @3);
    XCTAssertEqualObjects(d[@"B"], @3);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"E"], @2);
    XCTAssertEqualObjects(d[@"F"], @5);
    XCTAssertEqualObjects(d[@"G"], @5);
    XCTAssertEqualObjects(d[@"H"], @4);
    XCTAssertEqualObjects(d[@"I"], @4);
    XCTAssertEqual(d.rangeCount, 4U);
    //(A - B = 3, C - E = 2, F - H = 5, H - I = 4)

    testCase = 12; //add G-H
    [testCases addObject:@(testCase)];
    ret = [d from:@"G" to:@"H" setObject:@6];
    XCTAssertEqual(testCase, ret);
    XCTAssertEqualObjects(d[@"A"], @3);
    XCTAssertEqualObjects(d[@"B"], @3);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"E"], @2);
    XCTAssertEqualObjects(d[@"F"], @5);
    XCTAssertEqualObjects(d[@"G"], @6);
    XCTAssertEqualObjects(d[@"H"], @4);
    XCTAssertEqualObjects(d[@"I"], @4);
    XCTAssertEqual(d.rangeCount, 5U);
    //(A - B = 3, C - E = 2, F - G = 5, G - H = 6, H - I = 4)


    testCase = 4; //add F-H
    [testCases addObject:@(testCase)];
    ret = [d from:@"F" to:@"H" setObject:@7];
    XCTAssertEqual(testCase, ret);
    XCTAssertEqualObjects(d[@"A"], @3);
    XCTAssertEqualObjects(d[@"B"], @3);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"E"], @2);
    XCTAssertEqualObjects(d[@"F"], @7);
    XCTAssertEqualObjects(d[@"G"], @7);
    XCTAssertEqualObjects(d[@"H"], @4);
    XCTAssertEqualObjects(d[@"I"], @4);
    XCTAssertEqual(d.rangeCount, 4U);
    //(A - B = 3, C - E = 2, F - H = 7, H - I = 4)

    //prep for testcase below
    ret = [d from:@"K" to:@"M" setObject:@8];
    //(A - B = 3, C - E = 2, F - H = 7, H - I = 4, K - M = 8)

    testCase = 3; //add K-L
    [testCases addObject:@(testCase)];
    ret = [d from:@"K" to:@"L" setObject:@9];
    XCTAssertEqual(testCase, ret);
    XCTAssertEqualObjects(d[@"A"], @3);
    XCTAssertEqualObjects(d[@"B"], @3);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"E"], @2);
    XCTAssertEqualObjects(d[@"F"], @7);
    XCTAssertEqualObjects(d[@"G"], @7);
    XCTAssertEqualObjects(d[@"H"], @4);
    XCTAssertEqualObjects(d[@"I"], @4);
    XCTAssertNil(d[@"J"]);
    XCTAssertEqualObjects(d[@"K"], @9);
    XCTAssertEqualObjects(d[@"L"], @8);
    XCTAssertEqualObjects(d[@"M"], @8);
    XCTAssertEqual(d.rangeCount, 6U);
    //(A - B = 3, C - E = 2, F - H = 7, H - I = 4, K - L = 9, L - M = 8)


    testCase = 5; //add F-J
    [testCases addObject:@(testCase)];
    ret = [d from:@"F" to:@"J" setObject:@10];
    XCTAssertEqual(testCase, ret);
    XCTAssertEqualObjects(d[@"A"], @3);
    XCTAssertEqualObjects(d[@"B"], @3);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"E"], @2);
    XCTAssertEqualObjects(d[@"F"], @10);
    XCTAssertEqualObjects(d[@"G"], @10);
    XCTAssertEqualObjects(d[@"H"], @10);
    XCTAssertEqualObjects(d[@"I"], @10);
    XCTAssertEqualObjects(d[@"J"], @10);
    XCTAssertEqualObjects(d[@"K"], @9);
    XCTAssertEqualObjects(d[@"L"], @8);
    XCTAssertEqualObjects(d[@"M"], @8);
    XCTAssertEqual(d.rangeCount, 5U);
    //(A - B = 3, C - E = 2, F - J = 10, K - L = 9, L - M = 8)

    testCase = 6; //add K-N
    [testCases addObject:@(testCase)];
    ret = [d from:@"K" to:@"N" setObject:@11];
    XCTAssertEqual(testCase, ret);
    XCTAssertEqualObjects(d[@"A"], @3);
    XCTAssertEqualObjects(d[@"B"], @3);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"E"], @2);
    XCTAssertEqualObjects(d[@"F"], @10);
    XCTAssertEqualObjects(d[@"G"], @10);
    XCTAssertEqualObjects(d[@"H"], @10);
    XCTAssertEqualObjects(d[@"I"], @10);
    XCTAssertEqualObjects(d[@"J"], @10);
    XCTAssertEqualObjects(d[@"K"], @11);
    XCTAssertEqualObjects(d[@"L"], @11);
    XCTAssertEqualObjects(d[@"M"], @11);
    XCTAssertEqualObjects(d[@"N"], @11);
    XCTAssertEqual(d.rangeCount, 4U);
    //(A - B = 3, C - E = 2, F - J = 10, K - N = 11)

    testCase = 11; //add N-O)
    [testCases addObject:@(testCase)];
    ret = [d from:@"N" to:@"O" setObject:@12];
    XCTAssertEqual(testCase, ret);
    XCTAssertEqualObjects(d[@"A"], @3);
    XCTAssertEqualObjects(d[@"B"], @3);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"E"], @2);
    XCTAssertEqualObjects(d[@"F"], @10);
    XCTAssertEqualObjects(d[@"G"], @10);
    XCTAssertEqualObjects(d[@"H"], @10);
    XCTAssertEqualObjects(d[@"I"], @10);
    XCTAssertEqualObjects(d[@"J"], @10);
    XCTAssertEqualObjects(d[@"K"], @11);
    XCTAssertEqualObjects(d[@"L"], @11);
    XCTAssertEqualObjects(d[@"M"], @11);
    XCTAssertEqualObjects(d[@"N"], @12);
    XCTAssertEqualObjects(d[@"O"], @12);
    XCTAssertEqual(d.rangeCount, 5U);
    //(A - B = 3, C - E = 2, F - J = 10, K - N = 11, N - O = 12)


    //prep for testcase below
    d = [[RangeDictionary alloc] initWithComparator:Comparator];
    ret = [d from:@"B" to:@"C" setObject:@1];
    ret = [d from:@"C" to:@"E" setObject:@2];
    ret = [d from:@"E" to:@"F" setObject:@3];
    ret = [d from:@"D" to:@"E" setObject:@4];
    //(B - C = 1, C - D = 2, D - E = 4, E - F = 3)
    
    testCase = 9; //add C-D)
    [testCases addObject:@(testCase)];
    ret = [d from:@"C" to:@"D" setObject:@5];
    XCTAssertEqual(testCase, ret);
    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"B"], @1);
    XCTAssertEqualObjects(d[@"C"], @5);
    XCTAssertEqualObjects(d[@"D"], @4);
    XCTAssertEqualObjects(d[@"E"], @3);
    XCTAssertEqualObjects(d[@"E"], @3);
    XCTAssertEqual(d.rangeCount, 4U);
    //(B - C = 1, C - D = 5, D - E = 4, E - F = 3)


    //prep for testcase below
    d = [[RangeDictionary alloc] initWithComparator:Comparator];
    ret = [d from:@"B" to:@"D" setObject:@1];
    //(B - D = 1)

    testCase = 14; //add C-E
    [testCases addObject:@(testCase)];
    ret = [d from:@"C" to:@"E" setObject:@2];
    XCTAssertEqual(testCase, ret);
    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"B"], @1);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"E"], @2);
    XCTAssertEqual(d.rangeCount, 2U);
    //(B - C = 1, C - E = 2)

    //prep for testcase below
    d = [[RangeDictionary alloc] initWithComparator:Comparator];
    ret = [d from:@"B" to:@"D" setObject:@1];
    ret = [d from:@"C" to:@"E" setObject:@2];
    ret = [d from:@"E" to:@"G" setObject:@3];
    //(B - C = 1, C - E = 2, E - G = 3)

    testCase = 10; //add E-F
    [testCases addObject:@(testCase)];
    ret = [d from:@"E" to:@"F" setObject:@4];
    XCTAssertEqual(testCase, ret);
    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"B"], @1);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"E"], @4);
    XCTAssertEqualObjects(d[@"F"], @3);
    XCTAssertEqualObjects(d[@"G"], @3);
    XCTAssertEqual(d.rangeCount, 4U);

    //prep for testcase below
    d = [[RangeDictionary alloc] initWithComparator:Comparator];
    ret = [d from:@"A" to:@"B" setObject:@1];
    ret = [d from:@"C" to:@"D" setObject:@2];
    ret = [d from:@"E" to:@"H" setObject:@3];
    //(A - B = 1, C - D = 2, E - H = 3)
    
    testCase = 15; //add F-G
    [testCases addObject:@(testCase)];
    ret = [d from:@"F" to:@"G" setObject:@4];
    XCTAssertEqual(testCase, ret);
    XCTAssertEqualObjects(d[@"A"], @1);
    XCTAssertEqualObjects(d[@"B"], @1);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"E"], @3);
    XCTAssertEqualObjects(d[@"F"], @4);
    XCTAssertEqualObjects(d[@"G"], @3);
    XCTAssertEqualObjects(d[@"H"], @3);
    XCTAssertEqual(d.rangeCount, 5U);
    //(A - B = 1, C - D = 2, E - F = 3, F - G = 4, G - H = 3)

    //prep for testcase below
    d = [[RangeDictionary alloc] initWithComparator:Comparator];
    ret = [d from:@"A" to:@"B" setObject:@1];
    ret = [d from:@"C" to:@"D" setObject:@2];
    ret = [d from:@"E" to:@"H" setObject:@3];
    //(A - B = 1, C - D = 2, E - H = 3)

    testCase = 11; //add F-G
    [testCases addObject:@(testCase)];
    ret = [d from:@"B" to:@"I" setObject:@4];
    XCTAssertEqualObjects(d[@"A"], @1);
    XCTAssertEqualObjects(d[@"B"], @4);
    XCTAssertEqualObjects(d[@"C"], @4);
    XCTAssertEqualObjects(d[@"D"], @4);
    XCTAssertEqualObjects(d[@"E"], @4);
    XCTAssertEqualObjects(d[@"F"], @4);
    XCTAssertEqualObjects(d[@"G"], @4);
    XCTAssertEqualObjects(d[@"H"], @4);
    XCTAssertEqualObjects(d[@"I"], @4);
    XCTAssertEqual(d.rangeCount, 2U);
    //(A - B = 1, B - I = 4)

    //prep for testcase below
    d = [[RangeDictionary alloc] initWithComparator:Comparator];
    ret = [d from:@"A" to:@"C" setObject:@1];
    ret = [d from:@"D" to:@"E" setObject:@2];
    ret = [d from:@"F" to:@"H" setObject:@3];
    //(A - B = 1, C - D = 2, E - H = 3)

    testCase = 13;
    [testCases addObject:@(testCase)];
    ret = [d from:@"B" to:@"I" setObject:@4];
    XCTAssertEqualObjects(d[@"A"], @1);
    XCTAssertEqualObjects(d[@"B"], @4);
    XCTAssertEqualObjects(d[@"C"], @4);
    XCTAssertEqualObjects(d[@"D"], @4);
    XCTAssertEqualObjects(d[@"E"], @4);
    XCTAssertEqualObjects(d[@"F"], @4);
    XCTAssertEqualObjects(d[@"G"], @4);
    XCTAssertEqualObjects(d[@"H"], @4);
    XCTAssertEqualObjects(d[@"I"], @4);
    XCTAssertEqual(d.rangeCount, 2U);
    //(A - B = 1, B - I = 4)

    //list all the testcases we ran.
    for (NSUInteger n=1; n <= 18; ++n) {
        if ([testCases containsObject:@(n)]) {
            NSLog(@"case: %@", @(n));
        }
    }

    NSLog(@"");
}

/**
 * We used to have a bug in this situation.
 * The third insert starts at the same place as the first,
 * but overlaps both the first and second.
 * This requires both the first two ranges to change.
 */
-(void)testOverlapTwoFromStart {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"B" to:@"C"];
    [d setObject:@2 from:@"C" to:@"E"];
    [d setObject:@3 from:@"B" to:@"D"];

    XCTAssertNil(d[@"A"]);
    XCTAssertNil(d[@"Az"]);
    XCTAssertEqualObjects(d[@"B"], @3);
    XCTAssertEqualObjects(d[@"C"], @3);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"E"], @2);
    XCTAssertNil(d[@"Ea"]);
    XCTAssertNil(d[@"F"]);
    XCTAssertEqual(d.rangeCount, 2U);
}


/**
 * Same as above, but making sure that it works when three ranges are overlapped.
 */
-(void)testOverlapThreeFromStart {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"B" to:@"C"];
    [d setObject:@2 from:@"C" to:@"D"];
    [d setObject:@3 from:@"D" to:@"F"];
    [d setObject:@4 from:@"B" to:@"E"];

    XCTAssertNil(d[@"A"]);
    XCTAssertNil(d[@"Az"]);
    XCTAssertEqualObjects(d[@"B"], @4);
    XCTAssertEqualObjects(d[@"C"], @4);
    XCTAssertEqualObjects(d[@"D"], @4);
    XCTAssertEqualObjects(d[@"E"], @3);
    XCTAssertEqualObjects(d[@"F"], @3);
    XCTAssertNil(d[@"Fa"]);
    XCTAssertNil(d[@"G"]);
    XCTAssertEqual(d.rangeCount, 2U);
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
    XCTAssertEqual(d.rangeCount, 1U);
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
    XCTAssertEqual(d.rangeCount, 2U);
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
    XCTAssertEqual(d.rangeCount, 2U);
}


/**
 * We used to have a bug in this situation.
 * The second insert starts at the same place as the first,
 * but overlaps past the end of it, and there are no other
 * entries above.
 */
-(void)testInsertOverlapPastEnd {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"B" to:@"C"];
    [d setObject:@2 from:@"B" to:@"D"];

    XCTAssertNil(d[@"A"]);
    XCTAssertNil(d[@"Az"]);
    XCTAssertEqualObjects(d[@"B"], @2);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertNil(d[@"Da"]);
    XCTAssertNil(d[@"E"]);
    XCTAssertEqual(d.rangeCount, 1U);
}


/**
 * Same as above, but checking that we handle overlap of multiple ranges.
 */
-(void)testInsertOverlapPastEnd4 {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"B" to:@"C"];
    [d setObject:@2 from:@"C" to:@"D"];
    [d setObject:@3 from:@"D" to:@"E"];
    [d setObject:@4 from:@"E" to:@"F"];
    [d setObject:@5 from:@"B" to:@"G"];

    XCTAssertNil(d[@"A"]);
    XCTAssertNil(d[@"Az"]);
    XCTAssertEqualObjects(d[@"B"], @5);
    XCTAssertEqualObjects(d[@"C"], @5);
    XCTAssertEqualObjects(d[@"D"], @5);
    XCTAssertEqualObjects(d[@"E"], @5);
    XCTAssertEqualObjects(d[@"F"], @5);
    XCTAssertEqualObjects(d[@"G"], @5);
    XCTAssertNil(d[@"Ga"]);
    XCTAssertNil(d[@"H"]);
    XCTAssertEqual(d.rangeCount, 1U);
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
    XCTAssertEqual(d.rangeCount, 3U);

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
    XCTAssertEqual(d.rangeCount, 4U);
}


-(void)testCopy {
    NSMutableDictionary * v1 = [@{@1: @1} mutableCopy];
    NSMutableDictionary * v2 = [@{@2: @2} mutableCopy];
    NSMutableDictionary * v3 = [@{@3: @3} mutableCopy];
    NSMutableDictionary * v4 = [@{@4: @4} mutableCopy];
    NSMutableDictionary * v5 = [@{@5: @5} mutableCopy];
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:v1 from:@"B" to:@"C"];
    [d setObject:v2 from:@"C" to:@"E"];
    [d setObject:v3 from:@"E" to:@"F"];

    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"B"], v1);
    XCTAssertEqualObjects(d[@"Bz"], v1);
    XCTAssertEqualObjects(d[@"C"], v2);
    XCTAssertEqualObjects(d[@"D"], v2);
    XCTAssertEqualObjects(d[@"Dz"], v2);
    XCTAssertEqualObjects(d[@"E"], v3);
    XCTAssertEqualObjects(d[@"F"], v3);
    XCTAssertNil(d[@"G"]);
    XCTAssertEqual(d.rangeCount, 3U);

    RangeDictionary * d2 = [d copy];

    [d setObject:v4 from:@"D" to:@"E"];
    [d setObject:v5 from:@"C" to:@"D"];

    // d should have changed.
    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"B"], v1);
    XCTAssertEqualObjects(d[@"Bz"], v1);
    XCTAssertEqualObjects(d[@"C"], v5);
    XCTAssertEqualObjects(d[@"Cz"], v5);
    XCTAssertEqualObjects(d[@"D"], v4);
    XCTAssertEqualObjects(d[@"Dz"], v4);
    XCTAssertEqualObjects(d[@"E"], v3);  // Note @4 acts like [D, E) so this is correct.
    XCTAssertEqualObjects(d[@"F"], v3);
    XCTAssertNil(d[@"G"]);
    XCTAssertEqual(d.rangeCount, 4U);

    // d2 should not have changed.
    XCTAssertNil(d2[@"A"]);
    XCTAssertEqualObjects(d2[@"B"], v1);
    XCTAssertEqualObjects(d2[@"Bz"], v1);
    XCTAssertEqualObjects(d2[@"C"], v2);
    XCTAssertEqualObjects(d2[@"D"], v2);
    XCTAssertEqualObjects(d2[@"Dz"], v2);
    XCTAssertEqualObjects(d2[@"E"], v3);
    XCTAssertEqualObjects(d2[@"F"], v3);
    XCTAssertNil(d2[@"G"]);
    XCTAssertEqual(d2.rangeCount, 3U);

    // d and d2 are sharing keys and values though.
    // We're just testing values here.
    v1[@1] = @99;
    XCTAssertEqualObjects(d[@"B"][@1], @99);
    XCTAssertEqualObjects(d2[@"B"][@1], @99);
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
    XCTAssertEqual(d.rangeCount, 0U);
}


-(void)testToDictionary {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"B" to:@"D"];
    [d setObject:@2 from:@"C" to:@"E"];
    [d setObject:@3 from:@"E" to:@"F"];

    NSDictionary * dict = [d toDictionary];

    NSArray * expectedEntries = @[@{@"lo": @"B",
                                    @"hi": @"C",
                                    @"val": @1},
                                  @{@"lo": @"C",
                                    @"hi": @"E",
                                    @"val": @2},
                                  @{@"lo": @"E",
                                    @"hi": @"F",
                                    @"val": @3},
                                  ];
    XCTAssertEqualObjects(dict, @{@"entries": expectedEntries});
}


-(void)testToDictionaryMapped {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"B" to:@"D"];
    [d setObject:@2 from:@"C" to:@"E"];
    [d setObject:@3 from:@"E" to:@"F"];

    NSDictionary * dict = [d toDictionary:^NSString *(id kv) {
        return [NSString stringWithFormat:@"%@ %@", kv, kv];
    }];

    NSArray * expectedEntries = @[@{@"lo": @"B B",
                                    @"hi": @"C C",
                                    @"val": @"1 1"},
                                  @{@"lo": @"C C",
                                    @"hi": @"E E",
                                    @"val": @"2 2"},
                                  @{@"lo": @"E E",
                                    @"hi": @"F F",
                                    @"val": @"3 3"},
                                  ];
    XCTAssertEqualObjects(dict, @{@"entries": expectedEntries});
}


-(void)testInitWithDictionary {
    NSArray * entries = @[@{@"lo": @"B",
                            @"hi": @"C",
                            @"val": @1},
                          @{@"lo": @"C",
                            @"hi": @"E",
                            @"val": @2},
                          @{@"lo": @"E",
                            @"hi": @"F",
                            @"val": @3},
                          ];
    NSDictionary * dict = @{@"entries": entries};
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator dictionary:dict converter:NULL];

    XCTAssertNil(d[@"A"]);
    XCTAssertEqualObjects(d[@"B"], @1);
    XCTAssertEqualObjects(d[@"Bz"], @1);
    XCTAssertEqualObjects(d[@"C"], @2);
    XCTAssertEqualObjects(d[@"D"], @2);
    XCTAssertEqualObjects(d[@"Dz"], @2);
    XCTAssertEqualObjects(d[@"E"], @3);
    XCTAssertEqualObjects(d[@"F"], @3);
    XCTAssertNil(d[@"G"]);
    XCTAssertEqual(d.rangeCount, 3U);
}


-(void)testInitWithDictionaryBadDict {
    NSDictionary * dict = @{@"bad": [NSNull null]};
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator dictionary:dict converter:NULL];
    XCTAssertNil(d);
}


-(void)testInitWithDictionaryBadEntry {
    NSArray * entries = @[@{@"lo": @"B",
                            @"val": @1}];
    NSDictionary * dict = @{@"entries": entries};
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator dictionary:dict converter:NULL];
    XCTAssertNil(d);
}


-(void)testInitWithDictionaryBadConversion {
    NSArray * entries = @[@{@"lo": @"B",
                            @"hi": @"C",
                            @"val": @1}];
    NSDictionary * dict = @{@"entries": entries};
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator dictionary:dict converter:^id(__unused id obj) {
        return nil;
    }];
    XCTAssertNil(d);
}


-(void)testEnumerateEntries {
    RangeDictionary * d = [RangeDictionaryTests rangeDictionaryWithPattern1];

    NSMutableArray * losSeen = [NSMutableArray new];
    NSMutableArray * hisSeen = [NSMutableArray new];
    NSMutableArray * valsSeen = [NSMutableArray new];
    NSString * result = [d enumerateEntriesWithOptions:(NSEnumerationOptions)0 usingBlock:^(NSString * lo, NSString * hi, NSNumber * val, id * res, BOOL * stop) {
        [losSeen addObject:lo];
        [hisSeen addObject:hi];
        [valsSeen addObject:val];
        if ([lo isEqualToString:@"F"]) {
            *res = @"Done";
            *stop = YES;
        }
    }];

    XCTAssertEqualStrings(result, @"Done");
    XCTAssertEqualObjects(losSeen, (@[@"B", @"C", @"E", @"F"]));
    XCTAssertEqualObjects(hisSeen, (@[@"C", @"E", @"F", @"G"]));
    XCTAssertEqualObjects(valsSeen, (@[@1, @2, @4, @3]));
}


-(void)testMap {
    RangeDictionary * d = [RangeDictionaryTests rangeDictionaryWithPattern1];

    NSMutableArray * losSeen = [NSMutableArray new];
    NSMutableArray * hisSeen = [NSMutableArray new];
    NSMutableArray * valsSeen = [NSMutableArray new];
    NSMutableArray * result = [d map:^id(NSString * lo, NSString * hi, NSNumber * val) {
        [losSeen addObject:lo];
        [hisSeen addObject:hi];
        [valsSeen addObject:val];
        int val_i = val.intValue;
        return (val_i == 3 ? nil : @(val_i + 1));
    }];

    XCTAssertEqualObjects(result, (@[@2, @3, @5, @6]));
    XCTAssertEqualObjects(losSeen, (@[@"B", @"C", @"E", @"F", @"H"]));
    XCTAssertEqualObjects(hisSeen, (@[@"C", @"E", @"F", @"G", @"I"]));
    XCTAssertEqualObjects(valsSeen, (@[@1, @2, @4, @3, @5]));
}


-(void)testMapAllNil {
    RangeDictionary * d = [RangeDictionaryTests rangeDictionaryWithPattern1];

    NSMutableArray * result = [d map:^id(__unused NSString * lo, __unused NSString * hi, __unused NSNumber * val) {
        return nil;
    }];

    XCTAssertEqualObjects(result, (@[]));
}


+(RangeDictionary *)rangeDictionaryWithPattern1 {
    RangeDictionary * d = [[RangeDictionary alloc] initWithComparator:Comparator];
    [d setObject:@1 from:@"B" to:@"D"];
    [d setObject:@2 from:@"C" to:@"E"];
    [d setObject:@3 from:@"E" to:@"G"];
    [d setObject:@4 from:@"E" to:@"F"];
    [d setObject:@5 from:@"H" to:@"I"];
    return d;
}


@end


NS_ASSUME_NONNULL_END
