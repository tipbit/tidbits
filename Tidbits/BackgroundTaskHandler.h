//
//  BackgroundTaskHandler.h
//  Tidbits
//
//  Created by Ewan Mellor on 12/25/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StandardBlocks.h"


typedef void(^TaskBlock)(GetBoolBlock gameOver);


/**
 * A manager object for tasks that should be performed when the app is put into the background (cleanup tasks, for example).
 * This class registers for `UIApplicationDidEnterBackgroundNotification` and `UIApplicationWillEnterForegroundNotification`,
 * and will run the `taskBlock` given in the constructor whenever the app is backgrounded.
 *
 * taskBlock takes `(GetBoolBlock*)gameOver` as a parameter.  `taskBlock` should call `gameOver` at appropriate points
 * and if `gameOver` returns true then `taskBlock` should terminate immediately.  This will ensure that the app is not
 * killed by iOS for overrunning its allotted background time.  It also makes sure that `taskBlock` stops running if the app
 * comes back into the foreground.  An appropriate time to call `gameOver` might be at the start of each iteration of a loop,
 * or between large chunks of work.
 *
 * You should retain each BackgroundTaskHandler instance somewhere.  The registration for notifications will last only for the
 * lifetime of the instance.
 */
@interface BackgroundTaskHandler : NSObject

-(instancetype)init:(NSString*)taskName taskBlock:(TaskBlock)taskBlock __attribute__((nonnull));

@end
