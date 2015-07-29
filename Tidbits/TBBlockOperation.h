//
//  TBBlockOperation.h
//  Tidbits
//
//  Created by Kurt Bosselman on 7/28/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StandardBlocks.h"

@interface TBBlockOperation : NSOperation

@property (copy, nonatomic) NSOperationBlock operationBlock;

+ (instancetype) blockOperationWithBlock:(NSOperationBlock)operationBlock;

- (instancetype) initWithBlockOperationBlock:(NSOperationBlock)operationBlock;

@end
