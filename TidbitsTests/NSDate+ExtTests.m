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


@end
