//
//  NSDate+ISO8601Tests.m
//  Tidbits
//
//  Created by Ewan Mellor on 1/2/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSDate+ISO8601.h"

#import "TBTestCaseBase.h"


@interface NSDate_ISO8601Tests : TBTestCaseBase

@end


@implementation NSDate_ISO8601Tests


-(void)testDateFromIso8601Empty {
    XCTAssertNil([NSDate dateFromIso8601:@""]);
}


-(void)testDateFromIso8601Nil {
    XCTAssertNil([NSDate dateFromIso8601:nil]);
}


-(void)testDateFromIso8601Garbage {
    XCTAssertNil([NSDate dateFromIso8601:@"121212"]);
}


-(void)testDateFromIso8601TimeOnly {
    XCTAssertNil([NSDate dateFromIso8601:@"12:12:12Z"]);
}


-(void)testDateFromIso8601Millis {
    NSString* input = @"2013-04-01T20:42:33.388Z";
    NSDate* expected = [NSDate dateWithTimeIntervalSinceReferenceDate:386541753.388];
    NSDate* output = [NSDate dateFromIso8601:input];
    XCTAssertEqualObjects(output, expected);
}


-(void)testDateFromIso8601NoMillis {
    NSString* input = @"2013-04-01T20:42:33Z";
    NSDate* expected = [NSDate dateWithTimeIntervalSinceReferenceDate:386541753.0];
    NSDate* output = [NSDate dateFromIso8601:input];
    XCTAssertEqualObjects(output, expected);
}


-(void)testIso8601StringMillis {
    NSDate* input = [NSDate dateWithTimeIntervalSinceReferenceDate:386541753.401];
    NSString* expected = @"2013-04-01T20:42:33"; // Note millis and Z are dropped because iso8601String outputs the 19 char form.
    XCTAssertEqualObjects([input iso8601String], expected);
}


-(void)testIso8601StringNoMillis {
    NSDate* input = [NSDate dateWithTimeIntervalSinceReferenceDate:386541753.0];
    NSString* expected = @"2013-04-01T20:42:33"; // Note no Z because iso8601String outputs the 19 char form.
    XCTAssertEqualObjects([input iso8601String], expected);
}


-(void)testIso8601String_24Millis {
    NSDate* input = [NSDate dateWithTimeIntervalSinceReferenceDate:386541753.401];
    NSString* expected = @"2013-04-01T20:42:33.401Z";
    XCTAssertEqualObjects([input iso8601String_24], expected);
}


-(void)testIso8601String_24NoMillis {
    NSDate* input = [NSDate dateWithTimeIntervalSinceReferenceDate:386541753.0];
    NSString* expected = @"2013-04-01T20:42:33.000Z";
    XCTAssertEqualObjects([input iso8601String_24], expected);
}


@end
