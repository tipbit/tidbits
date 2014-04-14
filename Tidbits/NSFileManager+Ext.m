//
//  NSFileManager+Ext.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/7/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "Dispatch.h"
#import "LoggingMacros.h"
#import "NSError+Ext.h"

#import "NSFileManager+Ext.h"


@implementation NSFileManager (Ext)


-(unsigned long long)fileSize:(NSString*)path {
    NSError* err = nil;
    NSDictionary* attrs = [self attributesOfItemAtPath:path error:&err];
    if (attrs == nil) {
        NSLog(@"Failed to get attributes from %@", path);
        return ULONG_LONG_MAX;
    }
    else {
        return attrs.fileSize;
    }
}


-(void)removeItemAtURLAsync:(NSURL*)url {
    dispatchAsyncBackgroundThread(DISPATCH_QUEUE_PRIORITY_LOW, ^{
        NSError* err = nil;
        BOOL ok = [self removeItemAtURL:url error:&err];
        if (!ok && !err.isNoSuchFile)
            NSLog(@"Warning: Failed to remove %@", url);
    });
}


@end
