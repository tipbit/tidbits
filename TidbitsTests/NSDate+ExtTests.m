//
//  NSDate+ExtTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/30/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSDate+Ext.h"
#import "NSDate+ISO8601.h"

#import "TBTestCaseBase.h"


@interface NSDate_ExtTests : TBTestCaseBase

@end


@implementation NSDate_ExtTests


-(void)testIsSameUTCDayAs {
    [self doTestIsSameUTCDayAs:@"2014-12-30T00:00:00" b:@"2014-12-30T23:59:59" expected:YES];
    [self doTestIsSameUTCDayAs:@"2014-12-30T00:00:00" b:@"2014-12-31T00:00:00" expected:NO];
    [self doTestIsSameUTCDayAs:@"2014-12-30T23:59:59" b:@"2014-12-31T00:00:00" expected:NO];
    [self doTestIsSameUTCDayAs:@"2013-12-30T00:00:00" b:@"2014-12-30T00:00:00" expected:NO];
    [self doTestIsSameUTCDayAs:@"2013-12-31T23:59:59" b:@"2014-01-01T00:00:00" expected:NO];
}


-(void)doTestIsSameUTCDayAs:(NSString *)astr b:(NSString *)bstr expected:(BOOL)expected {
    NSDate * a = [NSDate dateFromIso8601:astr];
    NSDate * b = [NSDate dateFromIso8601:bstr];

    XCTAssertEqual([a isSameUTCDayAs:b], expected);
}


-(void)testDateByFixingTwoDigitYears {
    [self doTestDateByFixingTwoDigitYears:@"2014-12-30T00:00:00" expected:@"2014-12-30T00:00:00"];
    [self doTestDateByFixingTwoDigitYears:@"0014-12-30T00:00:00" expected:@"2014-12-30T00:00:00"];
    [self doTestDateByFixingTwoDigitYears:@"0071-12-30T00:00:00" expected:@"1971-12-30T00:00:00"];
    [self doTestDateByFixingTwoDigitYears:@"0004-02-29T12:00:00" expected:@"2004-02-29T12:00:00"];  // 2004 was a leap year (AD 4 was also, in the proleptic Gregorian calendar).
}


-(void)doTestDateByFixingTwoDigitYears:(NSString *)input expected:(NSString *)expected {
    NSDate * i = [NSDate dateFromIso8601:input];
    NSDate * e = [NSDate dateFromIso8601:expected];

    XCTAssertEqualObjects([i dateByFixingTwoDigitYears], e);
}


-(void)testStartOfMinute {
    [self doTestStartOfMinute:@"2015-06-07T01:02:03.647Z" expected:@"2015-06-07T01:02:00.000Z"];
    [self doTestStartOfMinute:@"2015-06-07T01:02:59.999Z" expected:@"2015-06-07T01:02:00.000Z"];
    [self doTestStartOfMinute:@"2015-06-07T23:59:59.999Z" expected:@"2015-06-07T23:59:00.000Z"];
    [self doTestStartOfMinute:@"2015-06-07T00:00:00.000Z" expected:@"2015-06-07T00:00:00.000Z"];
    [self doTestStartOfMinute:@"2004-02-29T23:59:30.000Z" expected:@"2004-02-29T23:59:00.000Z"];  // Leap year.
}


-(void)testEndOfMinute {
    [self doTestEndOfMinute:@"2015-06-07T01:02:03.647Z" expected:@"2015-06-07T01:02:59.999Z"];
    [self doTestEndOfMinute:@"2015-06-07T01:02:59.999Z" expected:@"2015-06-07T01:02:59.999Z"];
    [self doTestEndOfMinute:@"2015-06-07T23:59:59.999Z" expected:@"2015-06-07T23:59:59.999Z"];
    [self doTestEndOfMinute:@"2015-06-07T00:00:00.000Z" expected:@"2015-06-07T00:00:59.999Z"];
    [self doTestEndOfMinute:@"2004-02-29T23:59:30.000Z" expected:@"2004-02-29T23:59:59.999Z"];  // Leap year.
    [self doTestEndOfMinute:@"2015-06-30T23:59:30.000Z" expected:@"2015-06-30T23:59:59.999Z"];  // This day had a leap second,
                                                                                                // which we don't address in
                                                                                                // endOfMinute.
}


-(void)doTestStartOfMinute:(NSString *)input expected:(NSString *)expected {
    NSDate * i = [NSDate dateFromIso8601:input];
    NSDate * e = [NSDate dateFromIso8601:expected];

    XCTAssertEqualObjects(i.startOfMinute, e);
}


-(void)doTestEndOfMinute:(NSString *)input expected:(NSString *)expected {
    NSDate * i = [NSDate dateFromIso8601:input];
    NSDate * e = [NSDate dateFromIso8601:expected];

    XCTAssertEqualObjects(i.endOfMinute, e);
}


@end
