//
//  FileUtils.h
//  Tidbits
//
//  Created by Ewan Mellor on 7/6/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StandardBlocks.h"

@interface FileUtils : NSObject

/*!
 * Dispatch a background thread to read the named file.  The data read are mapped using NSDataReadingMappedIfSafe and
 * given to fileFound.  If the file does not exist or cannot be read, then fileNotFound is called instead.
 * Both the callbacks are on the background thread.
 */
+(void)asyncReadFile:(NSString*)path fileFound:(NSDataBlock)fileFound fileNotFound:(VoidBlock)fileNotFound;

/*!
 * Dispatch a background thread to write the given data to the named file.  This is done atomically (in the sense
 * of NSDataWritingAtomic).  One or other of the callbacks is called on the background thread when this call completes.
 *
 * This function will also create any necessary subdirectories.
 */
+(void)asyncWriteFile:(NSString*)path data:(NSData*)data onSuccess:(VoidBlock)onSuccess onFailure:(NSErrorBlock)onFailure;
+(void)asyncWriteFile:(NSString*)path data:(NSData*)data options:(NSDataWritingOptions) writeOptionsMask onSuccess:(VoidBlock)onSuccess onFailure:(NSErrorBlock)onFailure;

/*!
 * Call asyncWriteFile if data is set, or just call onSuccess if data is nil.
 *
 * This means that the callback can be either on the calling thread, or a background thread.
 */
+(void)asyncWriteFileIfDataSet:(NSString*)path data:(NSData*)data onSuccess:(VoidBlock)onSuccess onFailure:(NSErrorBlock)onFailure;
+(void)asyncWriteFileIfDataSet:(NSString*)path data:(NSData*)data options:(NSDataWritingOptions)writeOptionsMask onSuccess:(VoidBlock)onSuccess onFailure:(NSErrorBlock)onFailure;
@end
