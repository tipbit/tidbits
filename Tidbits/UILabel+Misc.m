//
//  UILabel+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/19/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "CALayer+Misc.h"
#import "CATransition+Misc.h"

#import "UILabel+Misc.h"

NS_ASSUME_NONNULL_BEGIN


@implementation UILabel (Misc)


-(nullable UIFont *)appearanceFont {
    return self.font;
}

-(void)setAppearanceFont:(nullable UIFont *)font {
    [self setFont:font];
}


-(void)tb_setText:(NSString *)text animatedWithDuration:(NSTimeInterval)duration {
    if (duration <= 0.0) {
        self.text = text;
        return;
    }

    NSString * const key = NSStringFromSelector(@selector(tb_setText:animatedWithDuration:));
    CATransition * animation = [CATransition transitionFadeEaseInEaseOutWithDuration:duration];
    [self.layer addAnimation:animation forKey:key andRemoveAfter:duration];
    self.text = text;
}


@end


NS_ASSUME_NONNULL_END
