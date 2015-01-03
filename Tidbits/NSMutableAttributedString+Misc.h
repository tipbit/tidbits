//
//  NSMutableAttributedString+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 1/2/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Misc)

-(instancetype)initWithAttributedString:(NSAttributedString *)attrStr extraAttrs:(NSDictionary *)extraAttrs;
-(instancetype)initWithAttributedString:(NSAttributedString *)attrStr foregroundColor:(UIColor *)fgColor;

@end
