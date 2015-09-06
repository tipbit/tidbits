//
//  Batcher.h
//  Tidbits
//
//  Created by Ewan Mellor on 11/29/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StandardBlocks.h"


/**
 * A Batcher will hold onto objects for you for a while, and then give you them back in a batch.
 *
 * It will hold onto the first object in the batch for at least minDelay, to give you a chance
 * to add more objects.  If you add another object then the batch will be delayed further,
 * to allow it to get even bigger.  This will continue until the first object has been delayed
 * by maxDelay, at which point the batch is sent even if new objects are still being added.
 *
 * This class does no thread operations of its own.  It uses performSelector on the thread that
 * you call addObject on, and you will be called back on that thread.
 */
@interface Batcher : NSObject

-(instancetype)initWithMinDelay:(NSTimeInterval)minDelay maxDelay:(NSTimeInterval)maxDelay onBatch:(NSMutableArrayBlock)onBatch;

-(void)addObject:(id)object __attribute__((nonnull));

/**
 * Force a batch to be sent immediately, rather than waiting for the timeout to expire.
 */
-(void)sendBatch;

@end
