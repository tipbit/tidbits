//
//  NSData+Ext.h
//  Tidbits
//
//  Created by Ewan Mellor on 12/7/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StandardBlocks.h"


@interface NSData (Ext)

/**
 * Write this data to a temporary file.  The temporary file will be in a subdirectory of its own inside NSCachesDirectory, and will be
 * named after the given filename.lastPathComponent.
 *
 * The onSuccess block is given the URL of the tempfile.  When you are done, you need to clean up the subdirectory that tempfile is in
 * (i.e. [tempfile URLByDeletingLastPathComponent]).  You can use NSFileManager.removeItemAtURLAsync for this.
 *
 * If something fails, onFailure is called (obviously).
 *
 * This call doesn't do any threading, other than asserting that it is running on a background thread.  You need to dispatch this call
 * to a background thread as appropriate.  The callbacks are called on the background thread, so you may need to dispatch those onto the main
 * thread.
 */
-(void)writeToTemporaryFileWithName:(NSString*)filename onSuccess:(NSURLBlock)onSuccess onFailure:(NSErrorBlock)onFailure __attribute__((nonnull(1)));

@end
