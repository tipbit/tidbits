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
    NSMutableArray* result = [input filter:^bool(id obj) {
        return true;
    }];

    XCTAssertIsKindOf(result, [NSMutableArray class]);
    XCTAssertEqualObjects(result, expected);
}


- (void)testFilterNearSameSize
{
    NSArray* input = @[@1, @2, @3, @4, @5, @6];
    NSArray* expected = @[@1, @2, @3, @4, @6];
    NSMutableArray* result = [input filter:^bool(id obj) {
        return [obj intValue] != 5;
    }];

    XCTAssertIsKindOf(result, [NSMutableArray class]);
    XCTAssertEqualObjects(result, expected);
}


- (void)testFilterMuchSmaller
{
    NSArray* input = @[@1, @2, @3, @4, @5, @6];
    NSArray* expected = @[@3];
    NSMutableArray* result = [input filter:^bool(id obj) {
        return [obj intValue] == 3;
    }];

    XCTAssertIsKindOf(result, [NSMutableArray class]);
    XCTAssertEqualObjects(result, expected);
}


- (void)testFilterEmpty
{
    NSArray* input = @[@1, @2, @3, @4, @5, @6];
    NSArray* expected = @[];
    NSMutableArray* result = [input filter:^bool(id obj) {
        return false;
    }];

    XCTAssertIsKindOf(result, [NSMutableArray class]);
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithKeysAndMappedValues {
    NSArray* input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{@1: @1, @2: @4, @4: @16};
    NSMutableDictionary* result = [input dictionaryWithKeysAndMappedValues:^id(id obj) {
        int v = [obj intValue];
        return v == 3 ? nil : @(v * v);
    }];
    XCTAssertIsKindOf(result, [NSMutableDictionary class]);
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithKeysAndMappedValuesEmpty {
    NSArray* input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{};
    NSMutableDictionary* result = [input dictionaryWithKeysAndMappedValues:^id(id obj) {
        return nil;
    }];
    XCTAssertIsKindOf(result, [NSMutableDictionary class]);
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithValuesAndMappedKeys {
    NSArray* input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{@1: @[@1], @4: @[@2], @16: @[@4]};
    NSMutableDictionary* result = [input dictionaryWithValuesAndMappedKeys:^id(id obj) {
        int v = [obj intValue];
        return v == 3 ? nil : @(v * v);
    }];
    XCTAssertIsKindOf(result, [NSMutableDictionary class]);
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithValuesAndMappedKeysEmpty {
    NSArray* input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{};
    NSMutableDictionary* result = [input dictionaryWithValuesAndMappedKeys:^id(id obj) {
        return nil;
    }];
    XCTAssertIsKindOf(result, [NSMutableDictionary class]);
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithValuesAndMappedKeysMerge {
    NSArray* input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{@"Odd": @[@1, @3], @"Even": @[@2, @4]};
    NSMutableDictionary* result = [input dictionaryWithValuesAndMappedKeys:^id(id obj) {
        int v = [obj intValue];
        return v % 2 == 0 ? @"Even" : @"Odd";
    }];
    XCTAssertIsKindOf(result, [NSMutableDictionary class]);
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithValuesAndUniqueMappedKeys {
    NSArray* input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{@1: @1, @4: @2, @16: @4};
    NSMutableDictionary* result = [input dictionaryWithValuesAndUniqueMappedKeys:^id(id obj) {
        int v = [obj intValue];
        return v == 3 ? nil : @(v * v);
    }];
    XCTAssertIsKindOf(result, [NSMutableDictionary class]);
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithValuesAndUniqueMappedKeysEmpty {
    NSArray* input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{};
    NSMutableDictionary* result = [input dictionaryWithValuesAndUniqueMappedKeys:^id(id obj) {
        return nil;
    }];
    XCTAssertIsKindOf(result, [NSMutableDictionary class]);
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithMappedKeysAndMappedValues {
    NSArray * input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{@10: @100, @40: @400};
    NSMutableDictionary* result = [input dictionaryWithMappedKeysAndMappedValues:^id(id obj) {
        int k = [obj intValue];
        return k == 3 ? nil : @(10 * k);
    } valueMapper:^id(id obj) {
        int v = [obj intValue];
        return v == 2 ? nil : @(100 * v);
    }];
    XCTAssertIsKindOf(result, [NSMutableDictionary class]);
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithMappedKeysAndMappedValuesEmpty {
    NSArray * input = @[];
    NSDictionary* expected = @{};
    NSMutableDictionary* result = [input dictionaryWithMappedKeysAndMappedValues:^id(id obj) {
        return obj;
    } valueMapper:^id(id obj) {
        return obj;
    }];
    XCTAssertIsKindOf(result, [NSMutableDictionary class]);
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithMappedKeysAndMappedValuesResultEmptyNilKey {
    NSArray * input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{};
    NSMutableDictionary* result = [input dictionaryWithMappedKeysAndMappedValues:^id(id obj) {
        return nil;
    } valueMapper:^id(id obj) {
        return obj;
    }];
    XCTAssertIsKindOf(result, [NSMutableDictionary class]);
    XCTAssertEqualObjects(result, expected);
}


-(void)testDictionaryWithMappedKeysAndMappedValuesResultEmptyNilValue {
    NSArray * input = @[@1, @2, @3, @4];
    NSDictionary* expected = @{};
    NSMutableDictionary* result = [input dictionaryWithMappedKeysAndMappedValues:^id(id obj) {
        return obj;
    } valueMapper:^id(id obj) {
        return nil;
    }];
    XCTAssertIsKindOf(result, [NSMutableDictionary class]);
    XCTAssertEqualObjects(result, expected);
}


-(void)testMapRemoveDuplicatesNoDupes {
    NSArray * input = @[@1, @2, @3, @4];
    NSArray * expected = @[@1, @4, @16];
    NSArray * result = [input mapRemoveDuplicates:^id(id obj) {
        int v = [obj intValue];
        return (v == 3 ? nil : @(v * v));
    }];
    XCTAssertIsKindOf(result, NSMutableArray);
    XCTAssertEqualObjects(result, expected);
}


-(void)testMapRemoveDuplicatesDupes {
    NSArray * input = @[@1, @2, @3, @4];
    NSArray * expected = @[@1, @0];
    NSArray * result = [input mapRemoveDuplicates:^id(id obj) {
        int v = [obj intValue];
        return (v == 3 ? nil : @(v % 2));
    }];
    XCTAssertIsKindOf(result, NSMutableArray);
    XCTAssertEqualObjects(result, expected);
}


-(void)testMapRemoveDuplicatesInputEmpty {
    NSArray * input = @[];
    NSArray * expected = @[];
    NSArray * result = [input mapRemoveDuplicates:^id(id obj) {
        int v = [obj intValue];
        return (v == 3 ? nil : @(v % 2));
    }];
    XCTAssertIsKindOf(result, NSMutableArray);
    XCTAssertEqualObjects(result, expected);
}


-(void)testMapRemoveDuplicatesResultEmpty {
    NSArray * input = @[@1, @2, @3, @4];
    NSArray * expected = @[];
    NSArray * result = [input mapRemoveDuplicates:^id(__unused id obj) {
        return nil;
    }];
    XCTAssertIsKindOf(result, NSMutableArray);
    XCTAssertEqualObjects(result, expected);
}


-(void)testMapAsyncDispatch {
    NSArray* input = @[@1, @2, @3, @4];
    NSArray* expected = @[@1, @4, @16];
    __block NSMutableArray * result = nil;
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
    XCTAssertIsKindOf(result, [NSMutableArray class]);
    XCTAssertEqualObjects(result, expected);
}


-(void)testMapAsyncNoThreads {
    NSArray* input = @[@1, @2, @3, @4];
    NSArray* expected = @[@1, @4, @16];
    __block NSMutableArray * result = nil;
    [input map_async:^(id obj, IdBlock onSuccess) {
        int v = [obj intValue];
        onSuccess(v == 3 ? nil : @(v * v));
    } onSuccess:^(NSMutableArray *array) {
        result = array;
    }];
    XCTAssertIsKindOf(result, [NSMutableArray class]);
    XCTAssertEqualObjects(result, expected);
}


-(void)testMapAsyncDispatchEmpty {
    NSArray* input = @[@1, @2, @3, @4];
    NSArray* expected = @[];
    __block NSMutableArray * result = nil;
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
    XCTAssertIsKindOf(result, [NSMutableArray class]);
    XCTAssertEqualObjects(result, expected);
}


@end
