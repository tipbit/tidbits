//
//  NSArray+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 10/3/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSArray+Misc.h"

@implementation NSArray (Misc)

-(id)objectAtIndex:(NSUInteger)index withDefault:(id)def {
    return index < self.count ? self[index] : def;
}


@end
