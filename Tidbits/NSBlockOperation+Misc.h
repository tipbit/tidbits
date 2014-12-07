//
//  NSBlockOperation+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 12/7/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StandardBlocks.h"


@interface NSBlockOperation (Misc)

/**
 * Like [NSBlockOperation blockOperationWithBlock:] but this passes the NSBlockOperation into the block too.
 *
 * This means that you can refer to the current operation, for example to find out what queuePriority it has.
 */
+(instancetype)blockOperationWithNSBlockOperationBlock:(NSBlockOperationBlock)block;

@end
