//
//  UIActionSheet+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 8/22/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIActionSheet (Misc)

-(BOOL)containsButtonWithTitle:(NSString *)title;

-(void)showFromSender:(nullable id)sender animated:(BOOL)animated;

@end


NS_ASSUME_NONNULL_END
