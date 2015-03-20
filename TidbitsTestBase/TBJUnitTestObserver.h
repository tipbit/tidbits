//
//  TBJUnitTestObserver.h
//  Tidbits
//
//  Created by Ewan Mellor on 3/19/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"

/**
 * An XCTestObserver that emits a test report in JUnit format.
 *
 * This also knows how to capture logging from Lumberjack, to include in the report.
 */
@interface TBJUnitTestObserver : XCTestObserver

@end

#pragma clang diagnostic pop
