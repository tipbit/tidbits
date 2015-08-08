//
//  UIViewController+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/7/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "UIViewController+Misc.h"


@implementation UIViewController (Misc)


-(BOOL)tb_isModal {
    return (self.presentingViewController.presentedViewController == self ||
            self.navigationController.presentingViewController.presentedViewController == self.navigationController ||
            [self.tabBarController.presentingViewController isKindOfClass:[UITabBarController class]]);
}


-(void)tb_dismissOrPop {
    if (self.tb_isModal) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
