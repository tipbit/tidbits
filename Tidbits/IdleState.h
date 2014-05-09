//
//  IdleState.h
//  TBClientLib
//
//  Created by Ewan Mellor on 5/9/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


extern volatile bool idleStateUserIdle;
extern volatile bool idleStateNetworkIdle;

extern NSString * const IdleStateChangedNotification;


/**
 * This class tracks the state of the application and whether it's idle, either in terms of the network or the user activity.
 *
 * idleStateUserIdle and idleStateNetworkIdle are updated as appropriate.  Whenever either of those changes, this module will
 * send an NSNotificationCenter notification named IdleStateChangedNotification.
 *
 * To track network traffic, call idleStateStartNetTimer early in your application startup (e.g. applicationDidBecomeActive).
 *
 * To track user activity, you must call userIsActive whenever the user is active.  This could be from a UIApplication.sendEvent: override,
 * for example.
 */
@interface IdleState : NSObject

+(void)startNetTimer;

/**
 * Call this method whenever the user is active, e.g. in your UIApplication.sendEvent: override.
 *
 * This will set idleStateUserIdle = false, and set a timer to set it back to true in 5 seconds.
 */
+(void)userIsActive;

@end
