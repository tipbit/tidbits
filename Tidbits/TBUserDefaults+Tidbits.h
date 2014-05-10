//
//  TBUserDefaults+Tidbits.h
//  Tidbits
//
//  Created by Ewan Mellor on 5/9/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#if DEBUG

#import "TBUserDefaults.h"

@interface TBUserDefaults (Tidbits)

// Should be set on TBUserDefaults.userDefaultsForUnauthenticatedUser.
@property (nonatomic) BOOL debugSimulateNSFileProtectionFailures;

@end

#endif
