//
//  NSAttributedString+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 1/2/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSAttributedString (Misc)

+(instancetype)attributedStringWithAttributedString:(NSAttributedString *)attrStr extraAttrs:(NSDictionary *)extraAttrs;
+(instancetype)attributedStringWithAttributedString:(NSAttributedString *)attrStr foregroundColor:(UIColor *)fgColor;

-(CGFloat)heightForWidth:(CGFloat)width;

@end
