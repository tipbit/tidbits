//
//  NSUserDefaults+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 1/28/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Misc)

/**
 * Equivalent to [self synchronize].
 *
 * This exists so that we have an intercept point for debugging.
 */
-(BOOL)tb_synchronize;

@end
