//
//  BlockWithResultOperation.m
//  TBClientLib
//
//  Created by Ewan Mellor on 6/7/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "BlockWithResultOperation.h"

@implementation BlockWithResultOperation {
    dispatch_block_with_result_t block;
}


-(instancetype)initWithBlock:(dispatch_block_with_result_t)blk {
    self = [super initWithTarget:self selector:@selector(invokeBlock) object:nil];
    if (self) {
        block = blk;
    }
    return self;
}


-(id)invokeBlock {
    return block();
}


@end
