//
//  UIView+Misc.h
//  Tipbit
//
//  Created by Ewan Mellor on 4/14/14.
//  Copyright (c) 2014 Tipbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Misc)

-(void)setRoundMask;
-(void)setRoundMask:(CGFloat)cornerRadius;

/**
 *  both left and x change origin.x
 */
@property (nonatomic) CGFloat x, left;

/**
 *  both top and y change origin.y
 */
@property (nonatomic) CGFloat y, top;

/**
 *  None of these properties change the size of the view.  They change just the position.
 */
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

/**
 *  change the frame.size.width or frame.size.height.
 */
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

/**
 *  change the height, leaving the bottom unchanged, and the top to @param.
 */
-(void)adjustRightTo:(CGFloat)right;
/**
 *  change the width, leaving the right unchanged, and the left to @param.
 */
-(void)adjustLeftTo:(CGFloat)left;
/**
 *  change the width, leaving right unchanged, and the left to @param.
 */
-(void)adjustTopTo:(CGFloat)top;
/**
 *  change the height, leaving the top unchanged, and the bottom to @param.
 */
-(void)adjustBottomTo:(CGFloat)bottom;

@end
