//
//  TBTestHelpers.h
//  Tidbits
//
//  Created by Ewan Mellor on 12/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Equivalent to `WaitFor(DEFAULT_TIMEOUT, block);`.
 */
extern bool WaitFor(bool (^block)(void));

/**
 * Equivalent to `WaitFor(0.0, NULL);`.  In other words, just ticks a small amount of work (0.3 seconds worth) on the main thread.
 */
extern bool WaitForMainThread(void);

/**
 * Evaluate the given block, and return when either it returns true or the timeout expires whichever is earlier.
 * The main run loop is executed for 0.3 seconds between each evaluation of the given block.  The intention is
 * that the block is evaluating some condition that will become true as a consequence of some work on the main thread.
 *
 * @param block May be NULL, which is equivalent to `^{ return false; }`.  This can be used to simply execute work
 * on the main thread until the timeout expires.
 */
extern bool WaitForTimeout(NSTimeInterval timeout, bool (^block)(void));

bool isReachable(NSString* hostname);
