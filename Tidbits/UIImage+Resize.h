//
//  UIImage+Resize.h
//  Tidbits
//
//  Created by Ewan Mellor on 7/2/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

-(UIImage*)resizedImageToSize:(CGSize)dstSize;
-(UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;

-(UIImage*)imageResizedTo:(CGSize)newSize;

-(UIImage*)imageResizedToFit:(CGSize)frameSize;

-(CGSize)sizeToFit:(CGSize)frameSize;

+(CGSize)sizeToFit:(CGSize)frameSize originalSize:(CGSize)originalSize;

@end
