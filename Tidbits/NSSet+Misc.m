//
//  NSSet+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 1/15/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "SynthesizeAssociatedObject.h"

#import "NSSet+Misc.h"


@interface NSSet ()

/**
 * This instance retains itself through this property for the duration of mapToArrayAsync.
 */
@property (nonatomic, strong) NSSet * tb_thisSelf;

@end


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


-(void)mapToArrayAsync:(id_to_id_async_t)mapper onSuccess:(NSMutableArrayBlock)onSuccess {
    self.tb_thisSelf = self;
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:self.count];
    [self mapToArrayAsync:mapper onSuccess:onSuccess enumerator:self.objectEnumerator result:result];
}

-(void) mapToArrayAsync:(id_to_id_async_t)mapper onSuccess:(NSMutableArrayBlock)onSuccess enumerator:(NSEnumerator *)enumerator result:(NSMutableArray *)result {
    id obj = enumerator.nextObject;

    if (obj == nil) {
        self.tb_thisSelf = nil;
        onSuccess(result);
        return;
    }

    NSSet * __weak weakSelf = self;
    mapper(obj, ^(id mapped_obj) {
        if (mapped_obj != nil) {
            [result addObject:mapped_obj];
        }
        [weakSelf mapToArrayAsync:mapper onSuccess:onSuccess enumerator:enumerator result:result];
    });
}


SYNTHESIZE_ASSOCIATED_OBJECT(tb_thisSelf, NSSet *, tb_thisSelf, setTb_thisSelf, OBJC_ASSOCIATION_RETAIN_NONATOMIC)


@end
