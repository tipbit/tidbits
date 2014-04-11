//
//  NSLayoutConstraintHelpers.m
//  Tidbits
//
//  Created by Ewan Mellor on 4/11/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSLayoutConstraintHelpers.h"


NSLayoutConstraint* con_1(id item, NSLayoutAttribute attr, NSLayoutRelation rel, CGFloat mul, CGFloat c) {
    return con_2(item, attr, rel, nil, NSLayoutAttributeNotAnAttribute, mul, c);
}


NSLayoutConstraint* con_2(id item1, NSLayoutAttribute attr1, NSLayoutRelation rel, id item2, NSLayoutAttribute attr2, CGFloat mul, CGFloat c) {
    return [NSLayoutConstraint constraintWithItem:item1 attribute:attr1 relatedBy:rel toItem:item2 attribute:attr2 multiplier:mul constant:c];
}
