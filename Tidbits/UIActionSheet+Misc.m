//
//  UIActionSheet+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/22/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "FeatureMacros.h"

#import "UIActionSheet+Misc.h"

NS_ASSUME_NONNULL_BEGIN


@implementation UIActionSheet (Misc)


-(BOOL)containsButtonWithTitle:(NSString *)title {
    for (NSInteger i = 0; i < self.numberOfButtons; i++) {
        if ([title isEqualToString:[self buttonTitleAtIndex:i]]) {
            return YES;
        }
    }
    return NO;
}


-(void)showFromSender:(nullable id)sender animated:(BOOL)animated {
    UIView * window = [UIApplication sharedApplication].keyWindow;

    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        // Sometimes our barButtonItem is hidden on redraw so use its current location instead
        //[self showFromBarButtonItem:(UIBarButtonItem *)sender animated:animated];

        UIView * targetView = (UIView *)[sender performSelector:@selector(view)];
        CGPoint point = [targetView.superview convertPoint:targetView.center toView:window];

        if (CGPointEqualToPoint(point, CGPointZero)) {
            [self showInView:window];
        }
        else {
            CGRect pointRect = CGRectMake(point.x, point.y, 1, 1);
            [self showFromRect:pointRect inView:window animated:animated];
        }
    }
    else if ([sender isKindOfClass:[UIView class]]) {
        UIView * view = (UIView *)sender;
        CGPoint point = [view.superview convertPoint:view.center toView:window];
        CGRect pointRect = CGRectMake(point.x, point.y, 1, 1);

        if (IS_IPAD || IS_IOS8_OR_GREATER) {
            [self showFromRect:pointRect inView:window animated:animated];
        }
        else {
            // for iphone iOS7 only
            [self showFromRect:pointRect inView:view.superview animated:animated];
        }
    }
    else {
        [self showInView:window];
    }
}


@end


NS_ASSUME_NONNULL_END
