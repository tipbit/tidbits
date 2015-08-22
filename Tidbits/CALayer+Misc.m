//
//  CALayer+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/21/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "CALayer+Misc.h"

NS_ASSUME_NONNULL_BEGIN


@implementation CALayer (Misc)


-(void)addAnimation:(CATransition *)animation forKey:(NSString *)key andRemoveAfter:(NSTimeInterval)duration {
    [self addAnimation:animation forKey:key];
    [self performSelector:@selector(removeAnimationForKey:) withObject:key afterDelay:duration];
}


@end


NS_ASSUME_NONNULL_END
