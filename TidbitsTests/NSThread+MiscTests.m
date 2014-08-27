//
//  NSThread+MiscTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/26/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSThread+Misc.h"

#import "TBTestCaseBase.h"


@interface NSThread_MiscTests : TBTestCaseBase

@end


@implementation NSThread_MiscTests


-(void)testFunctionFromCallstackLine {
    [self doTestFunctionFromCallstackLine:@"1   TBClientLibTests                    0x03a043c5 -[TBClientEngine(Session) login:onFailure:] + 757"
                                 expected:@"-[TBClientEngine(Session) login:onFailure:]"];
    [self doTestFunctionFromCallstackLine:@"2   TBClientLibTests                    0x03bc4566 __55-[TBClientListLoadableBase triggerRefreshInitialChecks]_block_invoke87 + 134"
                                 expected:@"__55-[TBClientListLoadableBase triggerRefreshInitialChecks]_block_invoke87"];
    [self doTestFunctionFromCallstackLine:@"2   TBClientLibTests                    0x03c3a2eb fireBlankCallbacks + 507"
                                 expected:@"fireBlankCallbacks"];
}


-(void)doTestFunctionFromCallstackLine:(NSString *)input expected:(NSString *)expected {
    XCTAssertEqualStrings([NSThread functionFromCallstackLine:input], expected);
}


@end
