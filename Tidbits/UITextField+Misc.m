//
//  UITextField+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/7/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "UITextField+Misc.h"


@implementation UITextField (Misc)


-(void)tb_setPlaceholderColor:(UIColor *)color {
    NSDictionary * attrs = @{NSForegroundColorAttributeName: color};
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
}


@end
