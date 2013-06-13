//
//  NSArray+Map.m
//  TBClientLib
//
//  Created by Ewan Mellor on 5/5/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSArray+Map.h"

@implementation NSArray (Map)

-(NSArray*) map:(id_to_id_t)mapper {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    for (id obj in self) {
        id new_obj = mapper(obj);
        if (new_obj != nil)
            [result addObject: new_obj];
    }
    return result;
}

@end
