//
//  UIImage+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/16/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "UIImage+Misc.h"

NS_ASSUME_NONNULL_BEGIN


@implementation UIImage (Misc)


-(UIImage *)imageByTintingWithColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 2.0);
    [self drawAtPoint:CGPointZero];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGRect frame = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextFillRect(context, frame);
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}


@end


NS_ASSUME_NONNULL_END
