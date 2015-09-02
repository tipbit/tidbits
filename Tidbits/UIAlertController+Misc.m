//
//  UIAlertController+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/22/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#ifdef __IPHONE_8_0

#import "UIAlertController+Misc.h"

NS_ASSUME_NONNULL_BEGIN


@implementation UIAlertController (Extras)


-(BOOL)containsActionWithTitle:(NSString *)title {
    for (UIAlertAction * alertAction in self.actions) {
        if ([title isEqualToString:alertAction.title]) {
            return YES;
        }
    }
    return NO;
}


-(void)centerInWindow {
    UIView * window = [UIApplication sharedApplication].keyWindow;
    UIPopoverPresentationController * presentationController = [self popoverPresentationController];
    presentationController.sourceView = window;
    presentationController.sourceRect = CGRectMake(window.center.x, window.center.y, 1, 1);
    presentationController.permittedArrowDirections = (UIPopoverArrowDirection)0;
}


-(void)positionFromSender:(nullable id)sender {
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        // Sometimes our barButtonItem is hidden on redraw so use its current location instead
        //presentationController.barButtonItem = (UIBarButtonItem *)sender;

        UIView * targetView = (UIView *)[sender performSelector:@selector(view)];
        UIView * window = [UIApplication sharedApplication].keyWindow;
        CGPoint point = [targetView.superview convertPoint:targetView.center toView:window];

        if (CGPointEqualToPoint(point, CGPointZero)) {
            [self centerInWindow];
        }
        else {
            [self positionAtPointInWindow:point];
        }
    }
    else if ([sender isKindOfClass:[UIView class]]) {
        UIView * senderView = (UIView *)sender;
        UIView * window = [UIApplication sharedApplication].keyWindow;
        CGPoint point = [senderView.superview convertPoint:senderView.center toView:window];
        [self positionAtPointInWindow:point];
    }
    else {
        [self centerInWindow];
    }
}


-(void)positionAtPointInWindow:(CGPoint)point {
    UIView * window = [UIApplication sharedApplication].keyWindow;
    UIPopoverPresentationController * presentationController = [self popoverPresentationController];
    presentationController.sourceView = window;
    presentationController.sourceRect = CGRectMake(point.x, point.y, 1, 1);
}


@end


NS_ASSUME_NONNULL_END

#endif
