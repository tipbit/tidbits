//
//  LogFormatterTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/25/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "LogFormatter.h"
#import "LoggingMacros.h"
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

    // We can have rounding differences between iso8601String_24 and formatLogMessage in the msec
    // part of the date.  Replace this character with ? for comparison purposes.
    result = [NSString stringWithFormat:@"%@?%@", [result substringToIndex:22], [result substringFromIndex:23]];

    NSString * expectedDateStr = [[[msg->timestamp iso8601String_24] substringToIndex:22] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString * expected = [NSString stringWithFormat:@"%@? debug test_func:99 | Test message", expectedDateStr];
    XCTAssertEqualStrings(result, expected);
}


-(void)testLogFormatterTTY {
    LogFormatterTTY * formatter = [[LogFormatterTTY alloc] init];
    DDLogMessage * msg = [self makeTestMessage];

    NSString * result = [formatter formatLogMessage:msg];

    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.formatterBehavior = NSDateFormatterBehavior10_4;
    dateFormatter.dateFormat = @"hh:mm:ss.SSS";

    NSString * expectedTimeStr = [dateFormatter stringFromDate:msg->timestamp];
    NSString * expected = [NSString stringWithFormat:@"D %@ %-4x 99   test_func Test message", expectedTimeStr, msg->machThreadID];
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
