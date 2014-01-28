//
//  NSUserDefaults+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 1/28/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "LoggingMacros.h"

#import "NSUserDefaults+Misc.h"


@implementation NSUserDefaults (Misc)


-(BOOL)tb_synchronize {
    DLog(@"");
    return [self synchronize];
}


@end
