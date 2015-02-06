//
//  BlockWithResultOperation.m
//  TBClientLib
//
//  Created by Ewan Mellor on 6/7/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "BlockWithResultOperation.h"


@interface BlockWithResultOperationHelper : NSObject

@property (nonatomic, copy) GetIdBlock block;

-(id)invokeBlock;

@end


@implementation BlockWithResultOperationHelper


-(id)invokeBlock {
    assert(self.block != nil);
    id result = self.block();
    self.block = nil;
    return result;
}


@end


@implementation BlockWithResultOperation


-(instancetype)initWithBlock:(GetIdBlock)blk {
    NSParameterAssert(blk);

    // initWithTarget creates an NSInvocation instance that retains its arguments, and puts that in self.invocation.
    // helper is therefore implicitly retained by this instance.
    // We need helper (rather than having invokeBlock defined by this class) to avoid a retain cycle.
    // There's no way to get NSInvocation to release its arguments once it's retained them;
    // setting self.invocation.target = nil doesn't do it, even though you'd expect it to, and self.invocation is readonly.

    BlockWithResultOperationHelper* helper = [[BlockWithResultOperationHelper alloc] init];
    helper.block = blk;
    self = [super initWithTarget:helper selector:@selector(invokeBlock) object:nil];
    return self;
}


@end
