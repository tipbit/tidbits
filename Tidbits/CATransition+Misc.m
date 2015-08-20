//
//  CATransition+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/19/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "CATransition+Misc.h"

NS_ASSUME_NONNULL_BEGIN


@implementation CATransition (Misc)


+(CATransition *)transitionFadeEaseInEaseOutWithDuration:(CFTimeInterval)duration {
    return [CATransition transitionWithDuration:duration
                                         timing:kCAMediaTimingFunctionEaseInEaseOut
                                           type:kCATransitionFade];
}


+(CATransition *)transitionWithDuration:(CFTimeInterval)duration timing:(NSString *)timing type:(NSString *)type {
    CATransition * animation = [CATransition animation];
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timing];
    animation.type = type;
    return animation;
}


@end


NS_ASSUME_NONNULL_END
