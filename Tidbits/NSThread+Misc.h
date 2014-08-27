//
//  NSThread+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 8/26/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread (Misc)

+(NSString *)callingFunction;

#if DEBUG
// Exposed for unit testing.
+(NSString *)functionFromCallstackLine:(NSString *)line;
#endif

@end
