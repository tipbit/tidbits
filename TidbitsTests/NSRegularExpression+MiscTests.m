//
//  NSRegularExpression+MiscTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 1/26/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSRegularExpression+Misc.h"

#import "TBTestCaseBase.h"


@interface NSRegularExpression_MiscTests_Multithreaded : NSObject

@property (nonatomic) NSRegularExpression * re;
@property (nonatomic) dispatch_group_t group1;
@property (nonatomic) dispatch_group_t group2;

@end

@implementation NSRegularExpression_MiscTests_Multithreaded

@end


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
    return [re hasMatchInString:input];
}


-(void)testMultithreaded {
    for (NSUInteger i = 0; i < 2; i++) {
        [self doTestMultithreaded];
    }
}


-(void)doTestMultithreaded {
    @autoreleasepool {
        NSError *error = nil;
        NSRegularExpression * re = [NSRegularExpression
                                    regularExpressionWithPattern:@"src=['\"]cid:([^'\"]*)['\"]"
                                    options:NSRegularExpressionCaseInsensitive
                                    error:&error];
        XCTAssert(re);
        XCTAssertNil(error);

        dispatch_group_t group1 = dispatch_group_create();
        dispatch_group_t group2 = dispatch_group_create();

        NSRegularExpression_MiscTests_Multithreaded * params = [[NSRegularExpression_MiscTests_Multithreaded alloc] init];
        params.re = re;
        params.group1 = group1;
        params.group2 = group2;

        for (NSUInteger i = 0; i < 10; i++) {
            dispatch_group_enter(group1);
            dispatch_group_enter(group2);
            [NSThread detachNewThreadSelector:@selector(doTestMultithreaded:) toTarget:self withObject:params];
        }

        dispatch_group_wait(group1, dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC));
    }
}


-(void)doTestMultithreaded:(NSRegularExpression_MiscTests_Multithreaded *)params {
    NSRegularExpression * re = params.re;
    dispatch_group_t group1 = params.group1;
    dispatch_group_t group2 = params.group2;

    NSData * randomData = [self makeRandomData:20000];
    NSString * testString = [NSString stringWithUTF8String:randomData.bytes];

    dispatch_group_leave(group2);
    dispatch_group_wait(group2, DISPATCH_TIME_FOREVER);

    for (NSUInteger i = 0; i < 1000; i++) {
        NSMutableArray * bits = [NSMutableArray array];
        [re enumerateMatchesInString:testString options:0 range:NSMakeRange(0, testString.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSString* bit = [testString substringWithRange:[result rangeAtIndex:1]];
            [bits addObject:bit];
        }];
    }

    dispatch_group_leave(group1);
}


-(NSData *)makeRandomData:(NSUInteger)n {
    char * bytes = malloc(n);
    for (NSUInteger i = 0; i < n - 1; i++) {
        bytes[i] = randomChar();
    }
    bytes[n - 1] = '\0';
    return [NSData dataWithBytesNoCopy:bytes length:n];
}


static char randomChar() {
    return (char)(32 + arc4random_uniform(94));
}


@end
