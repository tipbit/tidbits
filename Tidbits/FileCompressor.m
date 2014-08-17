//
//  FileCompressor.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/15/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//
// This is based loosely upon CompressingLogFileManager.m from CocoaLumberjack, licensed as follows:
// Software License Agreement (BSD License)
//
// Copyright (c) 2010, Deusty, LLC
// All rights reserved.
//
// Redistribution and use of this software in source and binary forms,
// with or without modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above
// copyright notice, this list of conditions and the
// following disclaimer.
//
// * Neither the name of Deusty nor the names of its
// contributors may be used to endorse or promote products
// derived from this software without specific prior
// written permission of Deusty, LLC.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
// FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
// WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <zlib.h>

#import "LoggingMacros.h"

#import "FileCompressor.h"


@implementation FileCompressor


+(BOOL)compressFile:(NSString *)srcPath removeSource:(BOOL)removeSource error:(NSError * __autoreleasing *)error {
    NSFileManager * nsfm = [NSFileManager defaultManager];

    NSDictionary * attrs = [nsfm attributesOfItemAtPath:srcPath error:error];
    if (attrs == nil) {
        NSError * err = (error == NULL ? nil : *error);
        NSLogWarn(@"Failed to get attributes of %@: %@", srcPath, err);
        return NO;
    }

    NSString *destPath = [srcPath stringByAppendingPathExtension:@"gz"];
    BOOL ok = [FileCompressor compressFile:srcPath to:destPath attributes:attrs error:error];
    if (ok && removeSource) {
        NSError * err = nil;
        ok = [nsfm removeItemAtPath:srcPath error:&err];
        if (!ok) {
            NSLogWarn(@"Failed to remove original file %@ after compression: %@", srcPath, err);
            // Return YES anyway, because we at least managed to make the compressed file.
        }

        return YES;
    }
    else {
        return ok;
    }
}


+(BOOL)compressFile:(NSString *)srcPath to:(NSString *)destPath attributes:(NSDictionary *)attributes error:(NSError * __autoreleasing *)error {
    NSFileManager * nsfm = [NSFileManager defaultManager];

    [nsfm createFileAtPath:destPath contents:nil attributes:attributes];

    NSInputStream * inputStream = [NSInputStream inputStreamWithFileAtPath:srcPath];
    NSOutputStream * outputStream = [NSOutputStream outputStreamToFileAtPath:destPath append:NO];

    [inputStream open];
    [outputStream open];

    BOOL ok = [FileCompressor compress:inputStream to:outputStream error:error];

    [inputStream close];
    [outputStream close];

    if (ok) {
        return YES;
    }
    else {
        // Remove the failed dest file, if any.
        NSError * err = nil;
        ok = [nsfm removeItemAtPath:destPath error:&err];
        if (!ok) {
            if ([err.domain isEqualToString:NSCocoaErrorDomain] && err.code == NSFileNoSuchFileError) {
                DLog(@"Dest file %@ already absent after failed compression", destPath);
            }
            else {
                NSLogError(@"Failed to clean up %@ after failed compression: %@", destPath, err);
            }
        }

        return NO;
    }
}


+(BOOL)compress:(NSInputStream *)inputStream to:(NSOutputStream *)outputStream error:(NSError * __autoreleasing *)error {
    z_stream stream;
    bzero(&stream, sizeof(stream));
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.total_out = 0;

    deflateInit2(&stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);

    BOOL result = [FileCompressor compress:inputStream to:outputStream zStream:stream error:error];

    deflateEnd(&stream);

    return result;
}


+(BOOL)compress:(NSInputStream *)inputStream to:(NSOutputStream *)outputStream zStream:(z_stream)zStream error:(NSError * __autoreleasing *)error {
    const NSUInteger bufsize = 8192;

    NSMutableData * inputBuf = [NSMutableData dataWithLength:bufsize];
    NSMutableData * outputBuf = [NSMutableData dataWithLength:bufsize];
    NSUInteger inputPos = 0;

    while (true) {
        @autoreleasepool {
            uint8_t * inputBytes = ((uint8_t *)[inputBuf mutableBytes]) + inputPos;
            NSUInteger inputlen = bufsize - inputPos;

            NSInteger readlen = [inputStream read:inputBytes maxLength:inputlen];
            if (readlen < 0) {
                if (error != NULL) {
                    *error = [inputStream streamError];
                }
                return NO;
            }

            inputPos += readlen;

            zStream.next_in = (Bytef *)[inputBuf bytes];
            zStream.avail_in = (uInt)inputPos;
            zStream.next_out = (Bytef *)[outputBuf mutableBytes];
            zStream.avail_out = (uInt)bufsize;

            uLong prevTotalIn = zStream.total_in;
            uLong prevTotalOut = zStream.total_out;

            int flush = [inputStream hasBytesAvailable] ? Z_SYNC_FLUSH : Z_FINISH;
            deflate(&zStream, flush);

            uLong inputProcessed = zStream.total_in - prevTotalIn;
            uLong numberToWrite = zStream.total_out - prevTotalOut;
            uLong totalWritelen = 0;

            do {
                const uint8_t * outputBuffer = ((const uint8_t *)[outputBuf bytes]) + totalWritelen;
                uLong outputLen = numberToWrite - totalWritelen;

                NSInteger writelen = [outputStream write:outputBuffer maxLength:outputLen];

                if (writelen < 0) {
                    if (error != NULL) {
                        *error = [outputStream streamError];
                    }
                    return NO;
                }

                totalWritelen += writelen;
            } while (totalWritelen < numberToWrite);

            NSUInteger inputRemaining = inputPos - inputProcessed;
            if (inputRemaining > 0) {
                void * inputDst = [inputBuf mutableBytes];
                const void * inputSrc = [inputBuf bytes] + inputProcessed;

                memmove(inputDst, inputSrc, inputRemaining);
            }

            inputPos = inputRemaining;

            if (flush == Z_FINISH && inputPos == 0) {
                return YES;
            }
        }
    }
}


@end
