//
//  NSInputStream+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 6/15/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInputStream (Misc)

/**
 * Equivalent to [NSInputStream inputStreamSafeWithFileAtPath:], but it
 * first checks whether the file is a regular file.
 *
 * If you use [NSInputStream inputStreamSafeWithFileAtPath:] with a directory
 * you get a stream that just reads \0 forever.  Which is bizarre.
 */
+(instancetype)inputStreamSafeWithFileAtPath:(NSString *)path error:(NSError * __autoreleasing *)error;

/**
 * @return 4 (the number of bytes read), 0 on EOF, or a negative number on failure.
 */
-(NSInteger)readUint32:(uint32_t*)result;

/**
 * @param length May be NSUIntegerMax, in which case no checks are performed.  Otherwise, this is used to check that the correct data were read.
 * @param error May be nil.
 * @return The data that was written to the file, using NSDataReadingMappedIfSafe to hopefully avoid reading it back from disk unless the caller needs it.
 * nil on failure, in which case *error will be set.
 */
-(NSData *)writeToFileAndNSData:(NSString *)filepath options:(NSDataWritingOptions)options length:(NSUInteger)length error:(NSError **)error __attribute__((nonnull(1)));

@end
