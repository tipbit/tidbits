//
//  UICollectionView+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/23/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "CALayer+Misc.h"
#import "CATransition+Misc.h"

#import "UICollectionView+Misc.h"

NS_ASSUME_NONNULL_BEGIN


@implementation UICollectionView (Misc)


-(void)tb_reloadDataAnimatedWithDuration:(NSTimeInterval)duration {
    if (duration <= 0.0) {
        [self reloadData];
        return;
    }

    NSString * const key = NSStringFromSelector(@selector(tb_reloadDataAnimatedWithDuration:));
    CATransition * animation = [CATransition transitionFadeEaseInEaseOutWithDuration:duration];
    [self.layer addAnimation:animation forKey:key andRemoveAfter:duration];
    [self reloadData];
}


@end


NS_ASSUME_NONNULL_END
