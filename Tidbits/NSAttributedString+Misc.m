//
//  NSAttributedString+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 1/2/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "NSMutableAttributedString+Misc.h"

#import "NSAttributedString+Misc.h"


@implementation NSAttributedString (Misc)


+(instancetype)attributedStringWithAttributedString:(NSAttributedString *)attrStr extraAttrs:(NSDictionary *)extraAttrs {
    return [[NSMutableAttributedString alloc] initWithAttributedString:attrStr extraAttrs:extraAttrs];
}


+(instancetype)attributedStringWithAttributedString:(NSAttributedString *)attrStr foregroundColor:(UIColor *)fgColor {
    return [[NSMutableAttributedString alloc] initWithAttributedString:attrStr foregroundColor:fgColor];
}


@end
