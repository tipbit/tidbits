//
//  NSString+MiscTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 10/18/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSString+Misc.h"


@interface NSString_MiscTests : XCTestCase

@end

@implementation NSString_MiscTests

- (void)testIsEarlierVersionThan {
    XCTAssert([@"1.0" isEarlierVersionThan:@"1.1"]);
    XCTAssert([@"1.0" isEarlierVersionThan:@"2.0"]);
    XCTAssert([@"1.0" isEarlierVersionThan:@"1.1.0"]);
    XCTAssert([@"1.0" isEarlierVersionThan:@"1.0.0"]);  // N.B.!
    XCTAssert([@"1.0.0" isEarlierVersionThan:@"1.1"]);
    XCTAssert([@"1.0.0a" isEarlierVersionThan:@"1.1"]);
    XCTAssert([@"1.0.0a" isEarlierVersionThan:@"1.0.0b"]);
    XCTAssert([@"1.0.0" isEarlierVersionThan:@"1.0.0a"]);
    XCTAssert([@"1.99.99" isEarlierVersionThan:@"1.100"]);
    XCTAssert(![@"2.0" isEarlierVersionThan:@"1.999"]);
    XCTAssert(![@"2.0" isEarlierVersionThan:@"2.0"]);
    XCTAssert(![@"2.0.0" isEarlierVersionThan:@"2.0"]);
}

@end
