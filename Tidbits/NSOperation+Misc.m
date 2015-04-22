//
//  NSOperation+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/10/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "SynthesizeAssociatedObject.h"

#import "NSOperation+Misc.h"


@implementation NSOperation (Misc)

SYNTHESIZE_ASSOCIATED_OBJECT(tb_name, NSString *, tb_name, setTb_name, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
SYNTHESIZE_ASSOCIATED_OBJECT(tb_userInfo, NSDictionary *, tb_userInfo, setTb_userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

@end
