//
//  UILabel+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 8/19/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UILabel (Misc)

@property (nonatomic, copy, nullable) UIFont * appearanceFont UI_APPEARANCE_SELECTOR;

-(void)tb_setText:(NSString *)text animatedWithDuration:(NSTimeInterval)duration;

@end


NS_ASSUME_NONNULL_END
