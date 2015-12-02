//
//  UIView+Misc.m
//  Tipbit
//
//  Created by Ewan Mellor on 4/14/14.
//  Copyright (c) 2014 Tipbit. All rights reserved.
//

#import "FeatureMacros.h"
#import "Reflection.h"

#import "UIView+Misc.h"


@implementation UIView (Misc)


-(instancetype)initWithNib {
    return [self initWithNibNamed:NSStringFromClass(self.class)];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
-(instancetype)initWithNibNamed:(NSString *)nibName {
#pragma clang diagnostic pop
    UIView * result = [self.class viewFromNibNamed:nibName forOwner:self];
    NSMutableArray * props = getOutlets(self.class);
    for (NSString * prop in props) {
        id val = [self valueForKey:prop];
        if (val != nil) {
            [result setValue:val forKey:prop];
        }
    }
    replaceActions(self, result, result);
    return result;
}


/*
 * There's no way to get the actual IBOutlets of a class (unless you're Interface Builder).
 * We approximate it by looking for weak readwrite properties with object type.  This works
 * out OK.
 */
static NSMutableArray * getOutlets(Class cls) {
    return reflectionGetPropertyNames(cls, ^BOOL(const char * attrs) {
        return reflectionPropertyAttributeStringMatches(attrs, ReflectionMatchRequireYes, ReflectionMatchRequireNo, ReflectionMatchRequireYes);
    });
}


/**
 * For the given view and any subviews, rebind any actions that are targeted at oldSelf
 * so that they target newSelf instead.
 */
static void replaceActions(UIView * oldSelf, UIView * newSelf, UIView * view) {
    if ([view isKindOfClass:[UIControl class]]) {
        UIControl * control = (UIControl *)view;
        NSSet * targets = control.allTargets;
        for (id target in targets) {
            if (target != oldSelf) {
                continue;
            }
            // UIControlEvents defines a bitwise flag for each event.
            // Everything between 1 << 0 and 1 << 19 is covered, except for the skiplist
            // that you see below.
            // This loop therefore is iterating over all known UIControlEvents entries.
            for (int i = 0; i < 20; i++) {
                if (i == 9 || i == 10 || i == 11 || i == 13 || i == 14 || i == 15) {
                    continue;
                }
                UIControlEvents event = (UIControlEvents)(1 << i);
                NSArray * actions = [control actionsForTarget:oldSelf forControlEvent:event];
                if (actions.count > 0) {
                    [control removeTarget:target action:NULL forControlEvents:event];
                    for (NSString * action in actions) {
                        [control addTarget:newSelf action:NSSelectorFromString(action) forControlEvents:event];
                    }
                }
            }
        }
    }
    for (UIView * subview in view.subviews) {
        replaceActions(oldSelf, newSelf, subview);
    }
}


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


-(void)addCenteredSubview:(UIView *)subview {
    [self addSubview:subview];
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],
                           [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]]];
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
    return [self viewFromNibNamed:NSStringFromClass(self) forOwner:nil];
}


+(instancetype)viewFromNibForOwner:(id)owner {
    return [self viewFromNibNamed:NSStringFromClass(self) forOwner:owner];
}


+(instancetype)viewFromNibNamed:(NSString *)nibName forOwner:(id)owner {
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


-(void)fadeAndRemoveFromSuperviewWithDuration:(NSTimeInterval)duration {
    typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.alpha = 0.0;
    } completion:^(__unused BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}


+ (CGSize)screenSize
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (!IS_IOS8_OR_GREATER && IS_LANDSCAPE) {
        return CGSizeMake(screenSize.height, screenSize.width);
    }
    return screenSize;
}

- (void) setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}
- (CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}
- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}
- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}
- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}
- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}
@end
