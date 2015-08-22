//
//  CALayer+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 8/21/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN


@interface CALayer (Misc)

-(void)addAnimation:(CATransition *)animation forKey:(NSString *)key andRemoveAfter:(NSTimeInterval)duration;

@end


NS_ASSUME_NONNULL_END
