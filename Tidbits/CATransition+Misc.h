//
//  CATransition+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 8/19/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN


@interface CATransition (Misc)

+(CATransition *)transitionFadeEaseInEaseOutWithDuration:(CFTimeInterval)duration;

/**
 * @param timing One of the kCAMediaTimingFunction* constants.
 * @param type One of the kCATransition* constants.
 */
+(CATransition *)transitionWithDuration:(CFTimeInterval)duration timing:(NSString *)timing type:(NSString *)type;

@end


NS_ASSUME_NONNULL_END
