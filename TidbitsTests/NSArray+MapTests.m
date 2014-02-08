//
//  NSArray+MapTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 10/9/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "TBTestCaseBase.h"
#import "TBTestHelpers.h"

#import "Dispatch.h"
#import "NSArray+Map.h"


@interface NSArray_MapTests : TBTestCaseBase

@end


@implementation NSArray_MapTests


- (void)testFilterAll
{
    NSArray* input = @[@1, @2, @3, @4, @5, @6];
    NSArray* expected = @[@1, @2, @3, @4, @5, @6];
    NSArray* result = [input filter:^bool(id obj) {
        return true;
    }];

    XCTAssertEqualObjects(result, expected);
}


- (void)testFilterNearSameSize
{
    NSArray* input = @[@1, @2, @3, @4, @5, @6];
    NSArray* expected = @[@1, @2, @3, @4, @6];
    NSArray* result = [input filter:^bool(id obj) {
        return [obj intValue] != 5;
    }];

    XCTAssertEqualObjects(result, expected);
}


- (void)testFilterMuchSmaller
{
    NSArray* input = @[@1, @2, @3, @4, @5, @6];
    NSArray* expected = @[@3];
    NSArray* result = [input filter:^bool(id obj) {
        return [obj intValue] == 3;
    }];

    XCTAssertEqualObjects(result, expected);
}


- (void)testFilterEmpty
{
    NSArray* input = @[@1, @2, @3, @4, @5, @6];
    NSArray* expected = @[];
    NSArray* result = [input filter:^bool(id obj) {
        return false;
    }];

    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithKeysAndMappedValues {
    NSArray* input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{@1: @1, @2: @4, @4: @16};
    NSDictionary* result = [input dictionaryWithKeysAndMappedValues:^id(id obj) {
        int v = [obj intValue];
        return v == 3 ? nil : @(v * v);
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithKeysAndMappedValuesEmpty {
    NSArray* input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{};
    NSDictionary* result = [input dictionaryWithKeysAndMappedValues:^id(id obj) {
        return nil;
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithValuesAndMappedKeys {
    NSArray* input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{@1: @[@1], @4: @[@2], @16: @[@4]};
    NSDictionary* result = [input dictionaryWithValuesAndMappedKeys:^id(id obj) {
        int v = [obj intValue];
        return v == 3 ? nil : @(v * v);
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithValuesAndMappedKeysEmpty {
    NSArray* input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{};
    NSDictionary* result = [input dictionaryWithValuesAndMappedKeys:^id(id obj) {
        return nil;
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithValuesAndMappedKeysMerge {
    NSArray* input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{@"Odd": @[@1, @3], @"Even": @[@2, @4]};
    NSDictionary* result = [input dictionaryWithValuesAndMappedKeys:^id(id obj) {
        int v = [obj intValue];
        return v % 2 == 0 ? @"Even" : @"Odd";
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithValuesAndUniqueMappedKeys {
    NSArray* input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{@1: @1, @4: @2, @16: @4};
    NSDictionary* result = [input dictionaryWithValuesAndUniqueMappedKeys:^id(id obj) {
        int v = [obj intValue];
        return v == 3 ? nil : @(v * v);
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithValuesAndUniqueMappedKeysEmpty {
    NSArray* input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{};
    NSDictionary* result = [input dictionaryWithValuesAndUniqueMappedKeys:^id(id obj) {
        return nil;
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testMapAsyncDispatch {
    NSArray* input = @[@1, @2, @3, @4];
    NSArray* expected = @[@1, @4, @16];
    __block NSArray* result = nil;
    WaitForTimeoutAsync(30.0, ^(bool *done) {
        [input map_async:^(id obj, IdBlock onSuccess) {
            dispatchAsyncMainThread(^{
                int v = [obj intValue];
                onSuccess(v == 3 ? nil : @(v * v));
            });
        } onSuccess:^(NSMutableArray *array) {
            dispatchAsyncMainThread(^{
                result = array;
                *done = true;
            });
        }];
    });
    XCTAssertEqualObjects(result, expected);
}


-(void)testMapAsyncNoThreads {
    NSArray* input = @[@1, @2, @3, @4];
    NSArray* expected = @[@1, @4, @16];
    __block NSArray* result = nil;
    [input map_async:^(id obj, IdBlock onSuccess) {
        int v = [obj intValue];
        onSuccess(v == 3 ? nil : @(v * v));
    } onSuccess:^(NSMutableArray *array) {
        result = array;
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testMapAsyncDispatchEmpty {
    NSArray* input = @[@1, @2, @3, @4];
    NSArray* expected = @[];
    __block NSArray* result = nil;
    WaitForTimeoutAsync(30.0, ^(bool *done) {
        [input map_async:^(id obj, IdBlock onSuccess) {
            dispatchAsyncMainThread(^{
                onSuccess(nil);
            });
        } onSuccess:^(NSMutableArray *array) {
            dispatchAsyncMainThread(^{
                result = array;
                *done = true;
            });
        }];
    });
    XCTAssertEqualObjects(result, expected);
}


@end
