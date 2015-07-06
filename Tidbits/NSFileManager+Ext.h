//
//  NSFileManager+Ext.h
//  Tidbits
//
//  Created by Ewan Mellor on 12/7/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Ext)

/**
 * @return The size in bytes of the file at the given path, or ULONG_LONG_MAX if an error occurred.
 *
 * This also logs the error, if any.
 */
-(unsigned long long)fileSize:(NSString*)path;

/**
 * Dispatches a low priority background task that calls [self removeItemAtURL:url error:...].
 * This logs but otherwise ignores any failures.
 * Use this for cleaning up temporary files or directories.
 */
-(void)removeItemAtURLAsync:(NSURL*)url;

+(NSString *)prettyFileSize:(unsigned long long)size;

@end
