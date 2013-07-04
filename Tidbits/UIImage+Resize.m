//
//  UIImage+Resize.m
//  Tidbits
//
//  Created by Ewan Mellor on 7/2/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "UIImage+Resize.h"


@implementation UIImage (Resize)


-(UIImage*)imageResizedTo:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}


-(UIImage*)imageResizedToFit:(CGSize)frameSize {
    CGSize selfSize = self.size;
    CGSize newSize = [self sizeToFit:frameSize];
    return newSize.width == selfSize.width && newSize.height == selfSize.height ? self : [self imageResizedTo:newSize];
}


-(CGSize)sizeToFit:(CGSize)frameSize {
    return [UIImage sizeToFit:frameSize originalSize:self.size];
}


+(CGSize)sizeToFit:(CGSize)frameSize originalSize:(CGSize)originalSize {
    CGSize fitWidth = originalSize.width > frameSize.width ? CGSizeMake(frameSize.width, frameSize.width * originalSize.height / originalSize.width) : originalSize;
    CGSize fitHeight = originalSize.height > frameSize.height ? CGSizeMake(frameSize.height * originalSize.width / originalSize.height, frameSize.height) : originalSize;
    return fitWidth.width > fitHeight.width ? fitHeight : fitWidth;
}


@end
