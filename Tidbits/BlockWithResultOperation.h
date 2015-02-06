//
//  BlockWithResultOperation.h
//  TBClientLib
//
//  Created by Ewan Mellor on 6/7/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StandardBlocks.h"


@interface BlockWithResultOperation : NSInvocationOperation

-(instancetype)initWithBlock:(GetIdBlock)blk __attribute__((nonnull));

@end
