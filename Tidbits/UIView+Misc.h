//
//  UIView+Misc.h
//  Tipbit
//
//  Created by Ewan Mellor on 4/14/14.
//  Copyright (c) 2014 Tipbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Misc)

/**
 * Equivalent to [self initWithNibNamed:NSStringFromClass(self.class)].
 */
-(instancetype)initWithNib;

/**
 * Use [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil]
 * to load a nib, and then check that the view has the correct type before returning it.
 *
 * This uses reflection to find the outlets on this class and to copy them into the result.
 *
 * @return The loaded UIView, or nil if nothing could not be loaded or a view of the wrong type was loaded.
 * You should use this like any other initializer, using the result to replace self and checking that it
 * was not nil.
 */
-(instancetype)initWithNibNamed:(NSString *)nibName;

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
 * Call [self addSubview:subview], then add constraints so the subview is centered in X and Y over this view.
 */
-(void)addCenteredSubview:(UIView *)subview;


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
 * Equivalent to [self viewFromNibNamed:NSStringFromClass(self) owner:nil].
 */
+(instancetype)viewFromNib;

/**
 * Equivalent to [self viewFromNibNamed:NSStringFromClass(self) owner:owner].
 */
+(instancetype)viewFromNibForOwner:(id)owner;

/**
 * Use [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil]
 * to load a nib, and then check that the view has the correct type before returning it.
 *
 * @return The loaded UIView, or nil if nothing could not be loaded or a view of the wrong type was loaded.
 */
+(instancetype)viewFromNibNamed:(NSString *)nibName forOwner:(id)owner;

/**
 * Use [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil]
 * to load a nib.
 *
 * Note that unlike initWithNib*, viewFromNibForOwner and
 * viewFromNibNamed:forOwner: above, there is no typecheck.
 * This is only here for legacy reasons and you should prefer the other functions.
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


/**
 * Animate self.alpha to 0.0 and then call [self removeFromSuperview].
 */
-(void)fadeAndRemoveFromSuperviewWithDuration:(NSTimeInterval)duration;


/**
 *  Screen size accounting for ios7/8 differences for portrait/landscape.
 */
+ (CGSize)screenSize;

//Allows us to use interface builder to set these properties.
//We are not adding property variables here, instead we are modifying existing layer properties.
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@end
