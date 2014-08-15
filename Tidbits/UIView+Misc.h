//
//  UIView+Misc.h
//  Tipbit
//
//  Created by Ewan Mellor on 4/14/14.
//  Copyright (c) 2014 Tipbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Misc)

-(void)setBorderColor:(UIColor *)color width:(CGFloat)width;
-(void)setBorderColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius;

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
 *  change the width, leaving the left unchanged.
 */
-(void)adjustRightTo:(CGFloat)right;
/**
 *  change the width, leaving the right unchanged.
 */
-(void)adjustLeftTo:(CGFloat)left;
/**
 *  change the height, leaving bottom unchanged.
 */
-(void)adjustTopTo:(CGFloat)top;
/**
 *  change the height, leaving the top unchanged.
 */
-(void)adjustBottomTo:(CGFloat)bottom;

/**
 * Call [self addSubview:subview], then add constraints so that it fills this view entirely.
 */
-(void)addFixedSubview:(UIView *)subview;

/**
 * Call [self addSubview:subview], then add constraints so that it is positioned as specified.
 */
-(void)addFixedSubview:(UIView *)subview x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h;

@end
