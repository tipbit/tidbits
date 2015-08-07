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
