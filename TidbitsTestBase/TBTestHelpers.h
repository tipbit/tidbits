//
//  TBTestHelpers.h
//  Tidbits
//
//  Created by Ewan Mellor on 12/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

bool WaitFor(bool (^block)(void));
bool WaitForTimeout(NSTimeInterval timeout, bool (^block)(void));
bool isReachable(NSString* hostname);
