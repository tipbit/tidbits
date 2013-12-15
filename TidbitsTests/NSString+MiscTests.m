//
//  NSString+MiscTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 10/18/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "TBTestCaseBase.h"

#import "NSString+Misc.h"


@interface NSString_MiscTests : TBTestCaseBase

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


-(void)testStringBySanitizingFilenameEmpty {
    XCTAssertEqualObjects([@"" stringBySanitizingFilename], @"");
}


-(void)testStringBySanitizingFilenameFullSentence {
    NSString* input = @"They can't want to make it this hard, can they";
    XCTAssertEqualObjects([input stringBySanitizingFilename], input);
}


-(void)testStringBySanitizingFilenameEitherOr {
    NSString* input = @"Raining cats / dogs";
    NSString* expected = @"Raining cats   dogs";
    XCTAssertEqualObjects([input stringBySanitizingFilename], expected);
}


-(void)testStringBySanitizingFilenameWindows {
    NSString* input = @"C:\\My Documents\\Please note.docx";
    NSString* expected = @"C My Documents Please note.docx";
    XCTAssertEqualObjects([input stringBySanitizingFilename], expected);
}


-(void)testStringBySanitizingFilenameUnicode {
    NSString* input = @"\tpiñata \\ Wałęsa / 汉语\n ";
    NSString* expected = @"piñata   Wałęsa   汉语";
    XCTAssertEqualObjects([input stringBySanitizingFilename], expected);
}


-(void)testStringBySanitizingFilenameRegexAwkward {
    NSString* input = @"[Lo] and <behold> -- it's a ^caret^ + an \"ampersand\" &c.";
    NSString* expected = @"[Lo] and  behold  -- it's a ^caret^ + an  ampersand  &c.";
    XCTAssertEqualObjects([input stringBySanitizingFilename], expected);
}


@end
