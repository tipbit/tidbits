//
//  BlockWithResultOperation.h
//  TBClientLib
//
//  Created by Ewan Mellor on 6/7/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Dispatch.h"

@interface BlockWithResultOperation : NSInvocationOperation

-(instancetype)initWithBlock:(dispatch_block_with_result_t)blk;

@end
