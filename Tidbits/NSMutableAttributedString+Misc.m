//
//  NSMutableAttributedString+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 1/2/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "NSMutableAttributedString+Misc.h"


@implementation NSMutableAttributedString (Misc)


-(instancetype)initWithAttributedString:(NSAttributedString *)attrStr extraAttrs:(NSDictionary *)extraAttrs {
    self = [self initWithAttributedString:attrStr];
    if (self) {
        NSRange range = NSMakeRange(0, self.length);
        for (NSString * k in extraAttrs) {
            [self removeAttribute:k range:range];
            [self addAttribute:k value:extraAttrs[k] range:range];
        }
    }
    return self;
}


-(instancetype)initWithAttributedString:(NSAttributedString *)attrStr foregroundColor:(UIColor *)fgColor {
    return [self initWithAttributedString:attrStr extraAttrs:@{NSForegroundColorAttributeName: fgColor}];
}


@end
