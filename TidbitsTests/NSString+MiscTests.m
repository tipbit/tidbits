//
//  NSString+MiscTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 10/18/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "TBTestCaseBase.h"

#import "NSString+MD5.h"
#import "NSString+Misc.h"


@interface NSString_MiscTests : TBTestCaseBase

@end


@implementation NSString_MiscTests


-(void)testcomponentsSeparatedByStringLimitEmpty {
    XCTAssertEqualObjects(@[], [@"" componentsSeparatedByString:@"," limit:2]);
}


-(void)testcomponentsSeparatedByStringLimitOnlyCommas5 {
    XCTAssertEqualObjects((@[@"", @"", @"", @"", @""]), [@",,,," componentsSeparatedByString:@"," limit:5]);
}


-(void)testcomponentsSeparatedByStringLimitOnlyCommas2of5 {
    XCTAssertEqualObjects((@[@"", @",,,"]), [@",,,," componentsSeparatedByString:@"," limit:2]);
}


-(void)testcomponentsSeparatedByStringLimitWordsCommas1of2 {
    XCTAssertEqualObjects((@[@"Peter,Piper"]), [@"Peter,Piper" componentsSeparatedByString:@"," limit:1]);
}


-(void)testcomponentsSeparatedByStringLimitWordsCommas2of2 {
    XCTAssertEqualObjects((@[@"Peter", @"Piper"]), [@"Peter,Piper" componentsSeparatedByString:@"," limit:2]);
}


-(void)testcomponentsSeparatedByStringLimitWordsCommas2of3 {
    XCTAssertEqualObjects((@[@"Peter", @"Piper,Parker"]), [@"Peter,Piper,Parker" componentsSeparatedByString:@"," limit:2]);
}


-(void)testcomponentsSeparatedByStringLimitWordsCommas4of3 {
    XCTAssertEqualObjects((@[@"Peter", @"Piper", @"Parker"]), [@"Peter,Piper,Parker" componentsSeparatedByString:@"," limit:4]);
}


-(void)testcomponentsSeparatedByStringLimitCat1of2 {
    XCTAssertEqualObjects((@[@"DogCatHog"]), [@"DogCatHog" componentsSeparatedByString:@"," limit:1]);
}


-(void)testcomponentsSeparatedByStringLimitCat2of2 {
    XCTAssertEqualObjects((@[@"Dog", @"Hog"]), [@"DogCatHog" componentsSeparatedByString:@"Cat" limit:2]);
}


-(void)testcomponentsSeparatedByStringLimitCat2of3 {
    XCTAssertEqualObjects((@[@"Dog", @"HogCatLog"]), [@"DogCatHogCatLog" componentsSeparatedByString:@"Cat" limit:2]);
}


-(void)testcomponentsSeparatedByStringLimitCat4of3 {
    XCTAssertEqualObjects((@[@"Dog", @"Hog", @"Log"]), [@"DogCatHogCatLog" componentsSeparatedByString:@"Cat" limit:4]);
}


-(void)testcomponentsSeparatedByStringLimitCatTrailing4of4 {
    XCTAssertEqualObjects((@[@"Dog", @"Hog", @"Log", @""]), [@"DogCatHogCatLogCat" componentsSeparatedByString:@"Cat" limit:4]);
}


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


-(void)testIsAllNumeric {
    XCTAssert([@"" isAllNumeric]);
    XCTAssert([@"42" isAllNumeric]);
    XCTAssert(![@" " isAllNumeric]);
    XCTAssert(![@"1.0" isAllNumeric]);
    XCTAssert(![@"1,0" isAllNumeric]);
    XCTAssert(![@"0xf" isAllNumeric]);
    XCTAssert(![@"f" isAllNumeric]);
    XCTAssert(![@"¼" isAllNumeric]);
    XCTAssert(![@"ℎ" isAllNumeric]);   // Planck's constant
    XCTAssert(![@"六" isAllNumeric]);  // Han number 6
    XCTAssert(![@"π" isAllNumeric]);   // Mmm, pi.
}


-(void)testEmailDomain {
    XCTAssertEqualStrings([@"test@example.com" emailDomain], @"example.com");
    XCTAssertNil([@"@example.com" emailDomain]);
    XCTAssertNil([@"test@" emailDomain]);
    XCTAssertNil([@"@" emailDomain]);
    XCTAssertNil([@"test.example.com" emailDomain]);
}


-(void)testEmailUser {
    XCTAssertEqualStrings([@"test@example.com" emailUser], @"test");
    XCTAssertNil([@"@example.com" emailUser]);
    XCTAssertNil([@"test@" emailUser]);
    XCTAssertNil([@"@" emailUser]);
    XCTAssertNil([@"test.example.com" emailUser]);
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
    NSString* expected = @"Raining cats dogs";
    XCTAssertEqualObjects([input stringBySanitizingFilename], expected);
}


-(void)testStringBySanitizingFilenameWindows {
    NSString* input = @"C:\\My Documents\\Please note.docx";
    NSString* expected = @"C My Documents Please note.docx";
    XCTAssertEqualObjects([input stringBySanitizingFilename], expected);
}


-(void)testStringBySanitizingFilenameUnicode {
    NSString* input = @"\tpiñata \\ Wałęsa / 汉语\n ";
    NSString* expected = @"piñata Wałęsa 汉语";
    XCTAssertEqualObjects([input stringBySanitizingFilename], expected);
}


-(void)testStringBySanitizingFilenameRegexAwkward {
    NSString* input = @"[Lo] and <behold> -- it's a ^caret^ + an \"ampersand\" &c.";
    NSString* expected = @"[Lo] and behold -- it's a ^caret^ + an ampersand &c.";
    XCTAssertEqualObjects([input stringBySanitizingFilename], expected);
}


-(void)testStringBySanitizingFilenameFullSentenceWithExtension {
    NSString* input = @"Tomorrow: Can you make \"Monday Indoor Soccer On Turf\"?.pdf";
    NSString* expected = @"Tomorrow Can you make Monday Indoor Soccer On Turf.pdf";
    XCTAssertEqualObjects([input stringBySanitizingFilename], expected);
}


-(void)testmd5uuid {
    NSString* input = @"asdfghjkl";
    NSUUID* expected = [[NSUUID alloc] initWithUUIDString:@"c44a471b-d78c-c6c2-fea3-2b9fe028d30a"];
    XCTAssertEqualObjects([input md5uuid], expected);
}


-(void)testmd5uuidEmpty {
    NSString* input = @"";
    NSUUID* expected = [[NSUUID alloc] initWithUUIDString:@"d41d8cd9-8f00-b204-e980-0998ecf8427e"];
    XCTAssertEqualObjects([input md5uuid], expected);
}


-(void)testStringByFoldingWhitespace {
    NSString * input = @"\n{\n    'foo' = 'bar';\nbaz=blish}\n.\n  \n";
    NSString * result = [input stringByFoldingWhitespace];
    XCTAssertEqualObjects(result, @"{ 'foo' = 'bar'; baz=blish} .");
}


-(void)testStringByDeletingCharactersInRangeNormal {
    NSString * input = @"This test has not passed";
    NSString * result = [input stringByDeletingCharactersInRange:NSMakeRange(13, 4)];
    XCTAssertEqualStrings(result, @"This test has passed");
}


-(void)testStringByDeletingCharactersInRangeOutOfRange {
    NSString * input = @"This test has not passed";
    XCTAssertThrowsSpecificNamed([input stringByDeletingCharactersInRange:NSMakeRange(99, 1)],
                                 NSException, NSRangeException);
}


-(void)testStringByDeletingCharactersInRangeOverlappingRange {
    NSString * input = @"This test has not passed";
    XCTAssertThrowsSpecificNamed([input stringByDeletingCharactersInRange:NSMakeRange(5, 99)],
                                 NSException, NSRangeException);
}


-(void)testStringByDeletingCharactersInRangeBlank {
    NSString * result = [@"" stringByDeletingCharactersInRange:NSMakeRange(0, 0)];
    XCTAssertEqualStrings(result, @"");
}


-(void)testStringByDeletingCharactersInSetNormal {
    NSString * input = @"'This test has'X' passed";
    NSString * result = [input stringByDeletingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"X'"]];
    XCTAssertEqualStrings(result, @"This test has passed");
}


-(void)testStringByDeletingCharactersInSetBlank {
    NSString * result = [@"" stringByDeletingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"ABC"]];
    XCTAssertEqualStrings(result, @"");
}


-(void)testStringByDeletingCharactersInSetNil {
    NSString * result = [@"This test has passed" stringByDeletingCharactersInSet:nil];
    XCTAssertEqualStrings(result, @"This test has passed");
}


-(void)testStringByDeletingCharactersInSetEmpty {
    NSString * result = [@"This test has passed" stringByDeletingCharactersInSet:[[NSCharacterSet alloc] init]];
    XCTAssertEqualStrings(result, @"This test has passed");
}


-(void)testStringByReplacingAllNormal {
    NSString * input = @"This [[A]] has [[B]]";
    NSString * result = [input stringByReplacingAll:@{@"[[A]]": @"test",
                                                      @"[[B]]": @"passed"}];
    XCTAssertEqualObjects(result, @"This test has passed");
}


-(void)testStringByReplacingAllNil {
    NSString * input = @"This [[A]] has [[B]]";
    NSString * result = [input stringByReplacingAll:nil];
    XCTAssertEqualObjects(result, @"This [[A]] has [[B]]");
}


-(void)testStringByReplacingAllBlank {
    NSString * input = @"This [[A]] has [[B]]";
    NSString * result = [input stringByReplacingAll:@{}];
    XCTAssertEqualObjects(result, @"This [[A]] has [[B]]");
}


-(void)testStringByReplacingAllNoHits {
    NSString * input = @"This [[A]] has [[B]]";
    NSString * result = [input stringByReplacingAll:@{@"[[C]]": @"test",
                                                      @"[[D]]": @"failed"}];
    XCTAssertEqualObjects(result, @"This [[A]] has [[B]]");
}


-(void)testStringByJoining {
    XCTAssertEqualStrings(@"", [NSString stringByJoining:nil with:nil]);
    XCTAssertEqualStrings(@"", [NSString stringByJoining:@"   " with:nil]);
    XCTAssertEqualStrings(@"Foo bar", [NSString stringByJoining:@" Foo  " with:@" bar  "]);
    XCTAssertEqualStrings(@"Foo", [NSString stringByJoining:@" Foo  " with:@"   "]);
    XCTAssertEqualStrings(@"bar", [NSString stringByJoining:nil with:@" bar  "]);
}


@end
