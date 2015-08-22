//
//  UITextField+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/7/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "CALayer+Misc.h"
#import "CATransition+Misc.h"

#import "UITextField+Misc.h"


@implementation UITextField (Misc)


-(void)tb_setPlaceholderColor:(UIColor *)color {
    NSDictionary * attrs = @{NSForegroundColorAttributeName: color};
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
}


-(void)tb_setText:(NSString *)text animatedWithDuration:(CGFloat)duration {
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
