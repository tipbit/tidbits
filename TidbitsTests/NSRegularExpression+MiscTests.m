//
//  NSRegularExpression+MiscTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 1/26/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSRegularExpression+Misc.h"

#import "TBTestCaseBase.h"


@interface NSRegularExpression_MiscTests : TBTestCaseBase

@end


@implementation NSRegularExpression_MiscTests


-(void)testWordPrefixCaseInsensitiveRegexAwkward {
    NSString* input = @"[Lo] and <behold> -- it's a ^caret^ + an \"ampersand\" &c.";

    XCTAssertFalse([self doWordPrefixCaseInsensitiveWith:input wordPrefix:nil]);
    XCTAssertFalse([self doWordPrefixCaseInsensitiveWith:input wordPrefix:@""]);
    XCTAssert([self doWordPrefixCaseInsensitiveWith:input wordPrefix:@"behold"]);
    XCTAssert([self doWordPrefixCaseInsensitiveWith:input wordPrefix:@"lo"]);
    XCTAssert([self doWordPrefixCaseInsensitiveWith:input wordPrefix:@"car"]);
    XCTAssertFalse([self doWordPrefixCaseInsensitiveWith:input wordPrefix:@"ret"]);
    XCTAssertFalse([self doWordPrefixCaseInsensitiveWith:input wordPrefix:@"ampersande"]);
    XCTAssert([self doWordPrefixCaseInsensitiveWith:input wordPrefix:@"amPERsan"]);
    XCTAssertFalse([self doWordPrefixCaseInsensitiveWith:input wordPrefix:@"mPERsan"]);
    XCTAssert([self doWordPrefixCaseInsensitiveWith:input wordPrefix:@"&c."]);
    XCTAssert([self doWordPrefixCaseInsensitiveWith:input wordPrefix:@"It's a"]);
}


-(bool)doWordPrefixCaseInsensitiveWith:(NSString*)input wordPrefix:(NSString*)wordPrefix {
    NSRegularExpression* re = [NSRegularExpression wordPrefixCaseInsensitive:wordPrefix];
    NSTextCheckingResult* match = [re firstMatchInString:input options:0 range:NSMakeRange(0, input.length)];
    return match != nil;
}


@end
