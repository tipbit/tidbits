//
//  UITabBarController+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/7/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "UITabBarController+Misc.h"


@implementation UITabBarController (Misc)


-(void)tb_replaceTabOfClass:(Class)class with:(UIViewController *)vc {
    NSMutableArray * vcs = [self.viewControllers mutableCopy];
    for (NSUInteger i = 0; i < vcs.count; i++) {
        if ([vcs[i] isKindOfClass:class]) {
            vcs[i] = vc;
            self.viewControllers = vcs;
            return;
        }
    }
}


@end
