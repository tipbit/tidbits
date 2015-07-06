//
//  NSFileManager+ExtTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 7/6/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "NSFileManager+Ext.h"

#import "TBTestCaseBase.h"


@interface NSFileManager_ExtTests : TBTestCaseBase

@end


@implementation NSFileManager_ExtTests


-(void)testPrettyFileSize {
    XCTAssertEqualStrings([NSFileManager prettyFileSize:0], @"0 bytes");
    XCTAssertEqualStrings([NSFileManager prettyFileSize:1], @"1 byte");
    XCTAssertEqualStrings([NSFileManager prettyFileSize:10], @"10 bytes");
    XCTAssertEqualStrings([NSFileManager prettyFileSize:1000], @"1 KB");
    XCTAssertEqualStrings([NSFileManager prettyFileSize:1024], @"1 KB");
    XCTAssertEqualStrings([NSFileManager prettyFileSize:40000], @"40 KB");
    XCTAssertEqualStrings([NSFileManager prettyFileSize:1000000], @"1 MB");
    XCTAssertEqualStrings([NSFileManager prettyFileSize:1024000], @"1 MB");
    XCTAssertEqualStrings([NSFileManager prettyFileSize:1 << 20], @"1 MB");
    XCTAssertEqualStrings([NSFileManager prettyFileSize:10000000], @"10 MB");
    XCTAssertEqualStrings([NSFileManager prettyFileSize:1000000000], @"1 GB");
    XCTAssertEqualStrings([NSFileManager prettyFileSize:1 << 30], @"1.07 GB");  // Not 1 GB.  But 1 << 20 is 1 MB.
                                                                                // Thanks, Apple.
    XCTAssertEqualStrings([NSFileManager prettyFileSize:NSUIntegerMax], @"");
    XCTAssertEqualStrings([NSFileManager prettyFileSize:ULONG_LONG_MAX], @"");
}


@end
