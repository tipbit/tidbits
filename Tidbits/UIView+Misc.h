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
 * Call [self addSubview:subview], then add constraints so that it is positioned surrounded 
 * with specified padding.
 */
-(void)addFixedSubview:(UIView *)subview withPaddingTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;
/**
 * Call [self addSubview:subview], then add constraints so that it is positioned as specified.
 */
-(void)addFixedSubview:(UIView *)subview x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h;

/**
 * Equivalent to [self viewFromNibForOwner:nil].
 */
+(instancetype)viewFromNib;

/**
 * Use [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:owner options:nil]
 * to load a nib, and then check that the view has the correct type before returning it.
 *
 * @return The loaded UIView, or nil if nothing could not be loaded or a view of the wrong type was loaded.
 */
+(instancetype)viewFromNibForOwner:(id)owner;

/**
 * Use [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil]
 * to load a nib.  Note that unlike viewFromNibForOwner above, there is no typecheck.
 *
 * @return The loaded UIView, or nil if nothing could not be loaded.
 */
+(UIView *)viewFromNib:(NSString *)nibName forOwner:(id)owner;

/**
 * Use [view addParallaxWithDefaultIntensity]
 * adds parallax motion to current view
 * default intensity is 10
 */
-(void) addParallaxWithDefaultIntensity;

/**
 * Use [view addParallaxWithIntensity:value]
 * adds parallax motion to current view
 * specifying custom intensity
 */
-(void) addParallaxWithIntensity:(CGFloat)intensity;

/** 
 * Use [view removeAllMotionEffects]
 * removes all motion parallax effects
 */
-(void) removeAllMotionEffects;

@end
