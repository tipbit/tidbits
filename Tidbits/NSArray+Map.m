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


-(void) map_async:(id_to_id_async_t)mapper onSuccess:(NSMutableArrayBlock)onSuccess {
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:self.count];
    [self map_async:mapper onSuccess:onSuccess idx:0 result:result];
}

-(void) map_async:(id_to_id_async_t)mapper onSuccess:(NSMutableArrayBlock)onSuccess idx:(NSUInteger)idx result:(NSMutableArray*)result {
    if (idx >= self.count) {
        onSuccess(result);
        return;
    }
    id obj = self[idx];
    NSArray* __weak weak_self = self;
    mapper(obj, ^(id mapped_obj) {
        if (mapped_obj != nil)
            [result addObject:mapped_obj];
        [weak_self map_async:mapper onSuccess:onSuccess idx:idx+1 result:result];
    });
}


@end
