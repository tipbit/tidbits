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
 * Dispatches a low priority background task that calls [self removeItemAtURL:url error:...].
 * This logs but otherwise ignores any failures.
 * Use this for cleaning up temporary files or directories.
 */
-(void)removeItemAtURLAsync:(NSURL*)url;

@end
