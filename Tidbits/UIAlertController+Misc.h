//
//  UIAlertController+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 8/22/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#ifdef __IPHONE_8_0

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIAlertController (Misc)

-(BOOL)containsActionWithTitle:(NSString *)title;

-(void)centerInView:(UIView *)aView;
-(void)positionFromSender:(nullable id)sender;

@end


NS_ASSUME_NONNULL_END

#endif
