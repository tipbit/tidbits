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


-(void)testStartOfMonth {
    [self doTestStartOfMonth:@"2015-06-07T01:02:03.647" expected:@"2015-06-01"];
    [self doTestStartOfMonth:@"2015-06-01T01:02:03.647" expected:@"2015-06-01"];
    [self doTestStartOfMonth:@"2015-06-30T23:59:59.999" expected:@"2015-06-01"];
    [self doTestStartOfMonth:@"2015-06-01T00:00:00.000" expected:@"2015-06-01"];
    [self doTestStartOfMonth:@"2004-02-29T23:59:30.000" expected:@"2004-02-01"];  // Leap year.
    [self doTestStartOfMonth:@"2004-03-01T00:00:00.000" expected:@"2004-03-01"];  // Leap year.
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


-(void)doTestStartOfMonth:(NSString *)input expected:(NSString *)expected {
    NSDate * iUTC = [NSDate dateFromIso8601:input];
    NSDate * eUTC = [NSDate dateFromIso8601:expected];

    NSTimeZone * tz = [NSTimeZone systemTimeZone];
    NSDate * i = [iUTC dateByAddingTimeInterval:-[tz secondsFromGMTForDate:iUTC]];
    NSDate * e = [eUTC dateByAddingTimeInterval:-[tz secondsFromGMTForDate:eUTC]];

    XCTAssertEqualObjects(i.startOfMonth, e);
}


-(void)testDateComparator {
    [self doTestComparator:@"2015-06-07T01:02:59.999Z" b:@"2015-06-07T01:02:59.999Z" expected:NSOrderedSame];
    [self doTestComparator:@"2015-06-07T01:02:59.999Z" b:@"2015-06-07T01:03:00.000Z" expected:NSOrderedAscending];
    [self doTestComparator:@"2015-06-07T01:02:59.999Z" b:@"2015-06-07T01:02:59.998Z" expected:NSOrderedDescending];
}


-(void)doTestComparator:(NSString *)a b:(NSString *)b expected:(NSComparisonResult)expected {
    NSDate * da = [NSDate dateFromIso8601:a];
    NSDate * db = [NSDate dateFromIso8601:b];

    XCTAssertEqual(NSDate.dateComparator(da, db), expected);
}


-(void)testDateComparatorMsecPrecision {
    [self doTestComparatorMsecPrecision:@"2015-06-07T01:02:59.999Z" usec:0 b:@"2015-06-07T01:02:59.999Z" usec:0 expected:NSOrderedSame];
    [self doTestComparatorMsecPrecision:@"2015-06-07T01:02:59.999Z" usec:0 b:@"2015-06-07T01:03:00.000Z" usec:0 expected:NSOrderedAscending];
    [self doTestComparatorMsecPrecision:@"2015-06-07T01:02:59.999Z" usec:0 b:@"2015-06-07T01:02:59.998Z" usec:0 expected:NSOrderedDescending];
    [self doTestComparatorMsecPrecision:@"2015-06-07T01:02:59.999Z" usec:0 b:@"2015-06-07T01:02:59.999Z" usec:400 expected:NSOrderedSame];
    [self doTestComparatorMsecPrecision:@"2015-06-07T01:02:30.000Z" usec:501 b:@"2015-06-07T01:02:30.001Z" usec:000 expected:NSOrderedSame];
    [self doTestComparatorMsecPrecision:@"2015-06-07T01:02:59.999Z" usec:400 b:@"2015-06-07T01:02:59.999Z" usec:0 expected:NSOrderedSame];
    [self doTestComparatorMsecPrecision:@"2015-06-07T01:02:30.001Z" usec:000 b:@"2015-06-07T01:02:30.000Z" usec:501 expected:NSOrderedSame];
    [self doTestComparatorMsecPrecision:@"2015-06-07T01:02:30.000Z" usec:499 b:@"2015-06-07T01:02:30.001Z" usec:000 expected:NSOrderedAscending];
    [self doTestComparatorMsecPrecision:@"2015-06-07T01:02:30.001Z" usec:000 b:@"2015-06-07T01:02:30.000Z" usec:499 expected:NSOrderedDescending];
}


-(void)doTestComparatorMsecPrecision:(NSString *)a usec:(NSInteger)usecA b:(NSString *)b usec:(NSInteger)usecB expected:(NSComparisonResult)expected {
    NSDate * da = [[NSDate dateFromIso8601:a] dateByAddingTimeInterval:(0.000001 * usecA)];
    NSDate * db = [[NSDate dateFromIso8601:b] dateByAddingTimeInterval:(0.000001 * usecB)];

    XCTAssertEqual(NSDate.dateComparatorMsecPrecision(da, db), expected);
}


@end
