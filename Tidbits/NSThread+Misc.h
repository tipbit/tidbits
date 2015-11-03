//
//  NSThread+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 8/26/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/NSString.h>
#import <Foundation/NSThread.h>

@interface NSThread (Misc)

+(NSString *)callingFunction;

#if DEBUG || RELEASE_TESTING
// Exposed for unit testing.
+(NSString *)functionFromCallstackLine:(NSString *)line;
#endif

@end
