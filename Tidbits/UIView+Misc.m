//
//  UIView+Misc.m
//  Tipbit
//
//  Created by Ewan Mellor on 4/14/14.
//  Copyright (c) 2014 Tipbit. All rights reserved.
//

#import "UIView+Misc.h"


@implementation UIView (Misc)


-(void)setBorderColor:(UIColor *)color width:(CGFloat)width {
    [self setBorderColor:color width:width radius:0.0f];
}


-(void)setBorderColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius {
    CALayer * l = self.layer;
    l.borderColor = color.CGColor;
    l.borderWidth = width;
    l.cornerRadius = radius;
}


-(void)setRoundMask {
    [self setRoundMask:self.layer.frame.size.width / 2.0f];
}

-(void)setRoundMask:(CGFloat)cornerRadius {
    CALayer *l = self.layer;
    l.cornerRadius = cornerRadius;
    l.borderWidth = 0;
    l.masksToBounds = YES;
}

@dynamic x, left;
-(CGFloat)x{
    return self.frame.origin.x;
}
-(void)setX:(CGFloat)left{
    self.frame = CGRectMake(left, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
-(CGFloat)left{ return self.x;}
-(void)setLeft:(CGFloat)left{[self setX:left];}

@dynamic y, top;
-(CGFloat)y{
    return self.frame.origin.y;
}
-(void)setY:(CGFloat)top{
    self.frame = CGRectMake(self.frame.origin.x, top, self.frame.size.width, self.frame.size.height);
}
-(CGFloat)top{return self.y;}
-(void)setTop:(CGFloat)top{[self setY:top];}

@dynamic right;
-(CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}
-(void)setRight:(CGFloat)right{
    self.frame = CGRectMake(right - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

@dynamic bottom;
-(CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}
-(void)setBottom:(CGFloat)bottom{
    self.frame = CGRectMake(self.frame.origin.x, bottom - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

@dynamic width;
-(CGFloat)width{
    return self.frame.size.width;
}
-(void)setWidth:(CGFloat)width{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}
@dynamic height;
-(CGFloat)height{
    return self.frame.size.height;
}
-(void)setHeight:(CGFloat)height{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

-(void)adjustRightTo:(CGFloat)right
{
    self.width = right - self.left;
}
-(void)adjustBottomTo:(CGFloat)bottom
{
    self.height = bottom - self.top;
}
-(void)adjustLeftTo:(CGFloat)left
{
    self.width = self.width + self.left - left;
    self.left = left;
}
-(void)adjustTopTo:(CGFloat)top
{
    self.height = self.height + self.top - top;
    self.top = top;
}


-(void)addFixedSubview:(UIView *)subview {
    [self addSubview:subview];
    CGRect frame = self.frame;
    subview.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(frame), CGRectGetHeight(frame));
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[subview]-0-|" options:0 metrics:nil views:@{@"subview": subview}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subview]-0-|" options:0 metrics:nil views:@{@"subview": subview}]];
}

-(void)addFixedSubview:(UIView *)subview withPaddingTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right
{
    [self addSubview:subview];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[subview]-%f-|", left,right] options:0 metrics:nil views:@{@"subview": subview}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[subview]-%f-|", top,bottom] options:0 metrics:nil views:@{@"subview": subview}]];
}

-(void)addFixedSubview:(UIView *)subview x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h {
    [self addSubview:subview];
    subview.frame = CGRectMake(x, y, w, h);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[subview(%f)]", x, w] options:0 metrics:nil views:@{@"subview": subview}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[subview(%f)]", y, h] options:0 metrics:nil views:@{@"subview": subview}]];
}


+(instancetype)viewFromNib {
    return [self viewFromNibForOwner:nil];
}


+(instancetype)viewFromNibForOwner:(id)owner {
    NSString * nibName = NSStringFromClass(self.class);
    NSArray * views = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
    for (id view in views) {
        if ([view isKindOfClass:self.class]) {
            return view;
        }
    }
    return nil;
}


+(UIView *)viewFromNib:(NSString *)nibName forOwner:(id)owner {
    NSArray * views = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
    return [views firstObject];
}

-(void) addParallaxWithDefaultIntensity
{
    [self addParallaxWithIntensity:10.f];
}

-(void) addParallaxWithIntensity:(CGFloat)intensity
{
    [self removeAllMotionEffects];
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-intensity);
    verticalMotionEffect.maximumRelativeValue = @(intensity);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-intensity);
    horizontalMotionEffect.maximumRelativeValue = @(intensity);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [self addMotionEffect:group];
}

-(void) removeAllMotionEffects
{
    for (UIMotionEffect* effect in self.motionEffects) {
        [self removeMotionEffect:effect];
    }
}

@end
