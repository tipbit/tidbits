//
//  FileCompressor.h
//  Tidbits
//
//  Created by Ewan Mellor on 8/15/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileCompressor : NSObject

/**
 * Call [FileCompressor:srcPath to:destPath attributes:attrs error:error]; where
 * destPath = [srcPath stringByAppendingPathExtension:@"gz"] and
 * attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:srcPath].
 *
 * @return YES on success, NO on failure.
 */
+(BOOL)compressFile:(NSString *)srcPath removeSource:(BOOL)removeSource error:(NSError * __autoreleasing *)error;

/**
 * Compress the file at the given srcPath using zlib, putting the result in destPath,
 * and giving destPath the given file attributes.
 *
 * @return YES on success, NO on failure.
 */
+(BOOL)compressFile:(NSString *)srcPath to:(NSString *)destPath attributes:(NSDictionary *)attributes error:(NSError * __autoreleasing *)error;

@end
