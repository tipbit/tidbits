//
//  LogFormatterTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/25/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "LogFormatter.h"
#import "LoggingMacros.h"
#import "NSDate+Ext.h"
#import "NSDate+ISO8601.h"

#import "TBTestHelpers.h"
#import "TBTestCaseBase.h"


@interface LogFormatterTests : TBTestCaseBase

@end


@implementation LogFormatterTests


-(void)testLogFormatter {
    LogFormatter * formatter = [[LogFormatter alloc] init];
    DDLogMessage * msg = [self makeTestMessage];

    NSString * result = [formatter formatLogMessage:msg];

    NSString * expectedDateStr = [[msg->timestamp iso8601String_23] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString * expected = [NSString stringWithFormat:@"%@ debug test_func:99 | Test message", expectedDateStr];
    XCTAssertEqualStrings(result, expected);
}


-(void)testLogFormatterTTY {
    LogFormatterTTY * formatter = [[LogFormatterTTY alloc] init];
    DDLogMessage * msg = [self makeTestMessage];

    NSString * result = [formatter formatLogMessage:msg];

    NSString * expectedTimeStr = [[msg->timestamp iso8601String_local_23] substringFromIndex:11];
    NSString * expected = [NSString stringWithFormat:@"D %@ test_func:99 | Test message", expectedTimeStr];
    XCTAssertEqualStrings(result, expected);
}


-(void)testLogFormatterTTYPerformanceComparison {
    LogFormatterTTY * formatter = [[LogFormatterTTY alloc] init];
    DDLogMessage * msg = [self makeTestMessage];

    comparePerformanceAndLogResult(^{
        [formatter formatLogMessage:msg];
    }, ^{
        [formatter formatLogMessageB:msg];
    });
}


-(DDLogMessage *)makeTestMessage {
    return [[DDLogMessage alloc] initWithLogMsg:@"Test message" level:LOG_LEVEL_DEBUG flag:LOG_FLAG_DEBUG context:0 file:"testfile.m" function:"test_func" line:99 tag:nil options:0];
}


@end
