//
//  UIViewController+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/7/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "UIViewController+Misc.h"

NS_ASSUME_NONNULL_BEGIN


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


-(void)tb_presentInNav:(UIViewController *)vc {
    [self tb_presentInNav:vc completion:NULL];
}


-(void)tb_presentInNav:(UIViewController *)vc completion:(nullable VoidBlock)completion {
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:nav animated:YES completion:completion];
}


@end


NS_ASSUME_NONNULL_END
