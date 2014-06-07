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


@implementation TBUserDefaults (Tidbits)

TBUSERDEFAULTS_REGISTER_BOOL_STANDARD(debugSimulateNSFileProtectionFailures, setDebugSimulateNSFileProtectionFailures, NSFileProtectionCompleteUntilFirstUserAuthentication, NO)

@end


#endif
