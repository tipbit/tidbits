//
//  NSBlockOperation+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/7/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "NSBlockOperation+Misc.h"


@implementation NSBlockOperation (Misc)


+(instancetype)blockOperationWithNSBlockOperationBlock:(NSBlockOperationBlock)block {
    __block NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        block(op);
    }];
    return op;
}


@end
