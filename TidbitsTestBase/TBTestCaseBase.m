//
//  TBTestCaseBase.m
//  Tidbits
//
//  Created by Ewan Mellor on 10/9/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "LogFormatter.h"

#import "TBTestCaseBase.h"


@implementation TBTestCaseBase


+(void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [LogFormatter formatterRegisteredAsDefaultASLAndTTY];
    });
}


-(void)setUp {
    self.continueAfterFailure = NO;
}


@end
