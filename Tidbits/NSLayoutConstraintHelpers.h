//
//  NSLayoutConstraintHelpers.h
//  Tidbits
//
//  Created by Ewan Mellor on 4/11/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSLayoutConstraint* con_1(id item, NSLayoutAttribute attr, NSLayoutRelation rel, CGFloat mul, CGFloat c);
extern NSLayoutConstraint* con_2(id item1, NSLayoutAttribute attr1, NSLayoutRelation rel, id item2, NSLayoutAttribute attr2, CGFloat mul, CGFloat c);
