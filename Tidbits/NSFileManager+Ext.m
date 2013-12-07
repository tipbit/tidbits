//
//  NSFileManager+Ext.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/7/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "Dispatch.h"
#import "LoggingMacros.h"

#import "NSFileManager+Ext.h"


@implementation NSFileManager (Ext)


-(void)removeItemAtURLAsync:(NSURL*)url {
    dispatchAsyncBackgroundThread(DISPATCH_QUEUE_PRIORITY_LOW, ^{
        NSError* err = nil;
        BOOL ok = [self removeItemAtURL:url error:&err];
        if (!ok && !(err.domain == NSCocoaErrorDomain && err.code == ENOENT))
            NSLog(@"Warning: Failed to remove %@", url);
    });
}


@end
