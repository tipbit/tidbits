//
//  TBTestCaseBase.h
//  Tidbits
//
//  Created by Ewan Mellor on 10/9/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TBTestCaseBase : XCTestCase

@end

bool WaitFor(bool (^block)(void));
bool isReachable(NSString* hostname);
