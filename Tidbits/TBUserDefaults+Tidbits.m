//
//  TBUserDefaults+Tidbits.m
//  Tidbits
//
//  Created by Ewan Mellor on 5/9/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#if DEBUG

#import "TBUserDefaultsRegisterSettings.h"

#import "TBUserDefaults+Tidbits.h"


#define kDebugSimulateNSFileProtectionFailures @"debugSimulateNSFileProtectionFailures"


@implementation TBUserDefaults (Tidbits)

TBUSERDEFAULTS_REGISTER_BOOL(debugSimulateNSFileProtectionFailures, setDebugSimulateNSFileProtectionFailures, kDebugSimulateNSFileProtectionFailures, NSFileProtectionCompleteUntilFirstUserAuthentication, NO)

@end


#endif
