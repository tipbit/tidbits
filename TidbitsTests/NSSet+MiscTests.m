//
//  NSSet+MiscTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 2/8/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Dispatch.h"

#import "TBTestCaseBase.h"

#import "NSSet+Misc.h"


@interface NSSet_MiscTests : TBTestCaseBase

@end


@implementation NSSet_MiscTests


-(void)testMapToArray {
    NSSet* input = [NSSet setWithObjects:@1, @2, @3, @4, nil];
    NSArray* expected = @[@1, @4, @16];
    NSArray* result = [input mapToArray:^id(id obj) {
        int v = [obj intValue];
        return v == 3 ? nil : @(v * v);
    }];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wselector"  // Silence warning about use of compare: below.
    XCTAssertEqualObjects([result sortedArrayUsingSelector:@selector(compare:)], expected);
#pragma clang diagnostic pop
}


-(void)testMapToArrayEmpty {
    NSSet* input = [NSSet set];
    NSArray* expected = @[];
    NSArray* result = [input mapToArray:^id(id obj) {
        int v = [obj intValue];
        return v == 3 ? nil : @(v * v);
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testMapToArrayEmptyResult {
    NSSet* input = [NSSet setWithObjects:@1, @2, @3, @4, nil];
    NSArray* expected = @[];
    NSArray* result = [input mapToArray:^id(id obj) {
        return nil;
    }];
    XCTAssertEqualObjects(result, expected);
}


-(void)testMapAsyncDispatch {
    NSSet * input = [NSSet setWithObjects:@1, @2, @3, @4, nil];
    NSArray * expected = @[@1, @4, @16];
    __block NSArray * result = nil;
    WaitForTimeoutAsync(30.0, ^(bool *done) {
        [input mapToArrayAsync:^(id obj, IdBlock onSuccess) {
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
    XCTAssertEqualObjects([result sortedArrayUsingSelector:@selector(compare:)], expected);
}


-(void)testMapAsyncNoThreads {
    NSSet * input = [NSSet setWithObjects:@1, @2, @3, @4, nil];
    NSArray * expected = @[@1, @4, @16];
    __block NSArray* result = nil;
    [input mapToArrayAsync:^(id obj, IdBlock onSuccess) {
        int v = [obj intValue];
        onSuccess(v == 3 ? nil : @(v * v));
    } onSuccess:^(NSMutableArray *array) {
        result = array;
    }];
    XCTAssertEqualObjects([result sortedArrayUsingSelector:@selector(compare:)], expected);
}


-(void)testMapAsyncDispatchEmpty {
    NSSet * input = [NSSet setWithObjects:@1, @2, @3, @4, nil];
    __block NSArray* result = nil;
    WaitForTimeoutAsync(30.0, ^(bool *done) {
        [input mapToArrayAsync:^(id obj, IdBlock onSuccess) {
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
    XCTAssertEqualObjects(result, @[]);
}


@end
