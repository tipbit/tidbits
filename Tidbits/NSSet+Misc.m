//
//  NSSet+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 1/15/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSSet+Misc.h"

@implementation NSSet (Misc)

-(NSArray*)mapToArray:(id_to_id_t)mapper {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        id new_obj = mapper(obj);
        if (new_obj != nil)
            [result addObject:new_obj];
    }];
    return result;
}

@end
