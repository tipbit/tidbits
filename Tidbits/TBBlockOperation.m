//
//  TBBlockOperation.m
//  Tidbits
//
//  Created by Kurt Bosselman on 7/28/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "TBBlockOperation.h"
#import "FeatureMacros.h"

@implementation TBBlockOperation

+ (instancetype) blockOperationWithBlock:(NSOperationBlock)operationBlock {
    TBBlockOperation *res = [[TBBlockOperation alloc] initWithBlockOperationBlock:operationBlock];
    return res;
}

- (instancetype) initWithBlockOperationBlock:(NSOperationBlock)operationBlock {
    self = [super init];
    if (self) {
        if (IS_IOS8_OR_GREATER) {
            self.name = NSStringFromClass([self class]);
        }
        
        self.operationBlock = operationBlock;
    }
    
    return self;
}

- (void) main {
    self.operationBlock(self);
}

@end
