//
//  UIViewController+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 8/7/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (Misc)

/**
 * YES if this view is has been presented modally.
 */
@property (nonatomic, readonly) BOOL tb_isModal;

/**
 * If this view is modal, dismiss it, otherwise pop it.  See tb_isModal.
 */
-(void)tb_dismissOrPop;

@end
