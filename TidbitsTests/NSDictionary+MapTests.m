//
//  NSDictionary+MapTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 2/8/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "TBTestCaseBase.h"

#import "NSDictionary+Map.h"


@interface NSDictionary_MapTests : TBTestCaseBase

@end


@implementation NSDictionary_MapTests


-(void)testMap {
    NSDictionary* input = @{@1: @2, @2: @3, @3: @4};
    NSArray* expected = @[@3, @5];
    NSArray* result = [input map:^id(id key, id val) {
        int k = [key intValue];
        int v = [val intValue];
        return k == 3 ? nil : @(k + v);
    }];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wselector"  // Silence warning about use of compare: below.
    XCTAssertEqualObjects([result sortedArrayUsingSelector:@selector(compare:)], expected);
#pragma clang diagnostic pop
}


-(void)testMapEmpty {
    NSDictionary* input = @{};
    NSArray* expected = @[];
    NSArray* result = [input map:^id(id key, id val) {
        int k = [key intValue];
        int v = [val intValue];
        return k == 3 ? nil : @(k + v);
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testMapResultEmpty {
    NSDictionary* input = @{@1: @2, @2: @3, @3: @4};
    NSArray* expected = @[];
    NSArray* result = [input map:^id(id key, id val) {
        return nil;
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithKeysAndMappedValues {
    NSDictionary* input = @{@1: @2, @2: @3, @3: @4};
    NSDictionary* expected = @{@1: @3, @2: @5};
    NSDictionary* result = [input dictionaryWithKeysAndMappedValues:^id(id key, id val) {
        int k = [key intValue];
        int v = [val intValue];
        return k == 3 ? nil : @(k + v);
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithKeysAndMappedValuesEmpty {
    NSDictionary* input = @{};
    NSDictionary* expected = @{};
    NSDictionary* result = [input dictionaryWithKeysAndMappedValues:^id(id key, id val) {
        int k = [key intValue];
        int v = [val intValue];
        return k == 3 ? nil : @(k + v);
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithKeysAndMappedValuesResultEmpty {
    NSDictionary* input = @{@1: @2, @2: @3, @3: @4};
    NSDictionary* expected = @{};
    NSDictionary* result = [input dictionaryWithKeysAndMappedValues:^id(id key, id val) {
        return nil;
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithMappedKeysAndMappedValues {
    NSDictionary* input = @{@1: @2, @2: @3, @3: @4, @4: @5};
    NSDictionary* expected = @{@3: @2, @9: @20};
    NSDictionary* result = [input dictionaryWithMappedKeysAndMappedValues:^id(id key, id val) {
        int k = [key intValue];
        int v = [val intValue];
        return k == 3 ? nil : @(k + v);
    } valueMapper:^id(id key, id val) {
        int k = [key intValue];
        int v = [val intValue];
        return k == 2 ? nil : @(k * v);
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithMappedKeysAndMappedValuesEmpty {
    NSDictionary* input = @{};
    NSDictionary* expected = @{};
    NSDictionary* result = [input dictionaryWithMappedKeysAndMappedValues:^id(id key, id val) {
        return key;
    } valueMapper:^id(id key, id val) {
        return val;
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithMappedKeysAndMappedValuesResultEmptyNilKey {
    NSDictionary* input = @{@1: @2, @2: @3, @3: @4};
    NSDictionary* expected = @{};
    NSDictionary* result = [input dictionaryWithMappedKeysAndMappedValues:^id(id key, id val) {
        return nil;
    } valueMapper:^id(id key, id val) {
        return val;
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithMappedKeysAndMappedValuesResultEmptyNilValue {
    NSDictionary* input = @{@1: @2, @2: @3, @3: @4};
    NSDictionary* expected = @{};
    NSDictionary* result = [input dictionaryWithMappedKeysAndMappedValues:^id(id key, id val) {
        return key;
    } valueMapper:^id(id key, id val) {
        return nil;
    }];
    XCTAssertEqualObjects(result, expected);
}


@end
