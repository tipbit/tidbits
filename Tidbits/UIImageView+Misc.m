//
//  UIImageView+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/21/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "CALayer+Misc.h"
#import "CATransition+Misc.h"

#import "UIImageView+Misc.h"

NS_ASSUME_NONNULL_BEGIN


@implementation UIImageView (Misc)


-(void)tb_setImage:(UIImage *)image animatedWithDuration:(NSTimeInterval)duration {
    if (duration <= 0.0) {
        self.image = image;
        return;
    }

    NSString * const key = NSStringFromSelector(@selector(tb_setImage:animatedWithDuration:));
    CATransition * animation = [CATransition transitionFadeEaseInEaseOutWithDuration:duration];
    [self.layer addAnimation:animation forKey:key andRemoveAfter:duration];
    self.image = image;
}


@end


NS_ASSUME_NONNULL_END
