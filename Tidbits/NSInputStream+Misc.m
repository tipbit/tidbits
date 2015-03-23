//
//  NSInputStream+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 6/15/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "LoggingMacros.h"
#import "NSData+NSInputStream.h"
#import "NSError+Ext.h"
#import "NSFileHandle+Misc.m"
#import "TBUserDefaults+Tidbits.h"

#import "NSInputStream+Misc.h"


#define BUFSIZE 4096


@implementation NSInputStream (Misc)


+(instancetype)inputStreamSafeWithFileAtPath:(NSString *)path error:(NSError * __autoreleasing *)error {
    NSFileManager * nsfm = [NSFileManager defaultManager];

    BOOL dir;
    BOOL ok = [nsfm fileExistsAtPath:path isDirectory:&dir];
    if (!ok) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:ENOENT userInfo:nil];
        }
        return nil;
    }

    if (dir) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EISDIR userInfo:nil];
        }
        return nil;
    }

    return [NSInputStream inputStreamWithFileAtPath:path];
}


-(NSInteger)readUint32:(uint32_t*)result {
    return readLen(self, (u_int8_t*)result, 4);
}


static NSInteger readLen(NSInputStream* is, u_int8_t* dest, NSUInteger len) {
    int n = 0;
    while (true) {
        NSInteger i = [is read:(dest + n) maxLength:len - n];
        if (i <= 0)
            return i;

        n += i;

        if ((NSUInteger)n == len)
            return n;
    }
}


-(NSData *)writeToFileAndNSData:(NSString *)filepath options:(NSDataWritingOptions)options length:(NSUInteger)length error:(NSError *__autoreleasing *)error __attribute__((nonnull(1))) {
    NSParameterAssert(filepath);

    NSError * err = nil;
    NSFileManager * nsfm = [NSFileManager defaultManager];
    BOOL ok = [nsfm removeItemAtPath:filepath error:&err];
    if ((!ok || err != nil) && !err.isNoSuchFile) {
        DLog(@"Warning: failed to remove %@: %@.  Ignoring, but this probably will cause the move to fail.", filepath, err);
    }

    NSString * temppath = [filepath stringByAppendingPathExtension:@"tmp"];
    NSFileHandle * file = openFile(temppath, options, &err);
    if (file == nil) {
        DLog(@"Cannot open file %@; falling back to just returning the NSData: %@", filepath, err);
        return [NSData dataWithContentsOfStream:self initialCapacity:length error:error];
    }

    NSData * result;
    ok = [self writeToFileHandle:file error:error];
    if (ok) {
        err = nil;
        ok = [nsfm moveItemAtPath:temppath toPath:filepath error:&err];
        if (!ok || err != nil) {
            NSLog(@"Got error when trying to move %@ to %@: %@.  Just returning the data.", temppath, filepath, err);
            filepath = temppath;
        }

        result = [NSData dataWithContentsOfFile:filepath options:NSDataReadingMappedIfSafe error:error];
        if (result == nil) {
            NSLogError(@"Failed to load data %@ having just successfully put it there: %@", filepath, *error);
        }
        if (length != NSUIntegerMax && result.length != length) {
            NSLogError(@"Content of %@ is not the right length %lu; discarding.", filepath, (unsigned long)length);
            if (error) {
                *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EIO userInfo:nil];
            }
            result = nil;
        }
    }
    else {
        result = nil;
    }

    // Note that we don't close the file until we have made the NSData.
    // If the file is using FileProtectionCompleteUnlessOpen, this is important.
    [file closeFile];

    return result;
}


/**
 * @return true on success, false otherwise with *error set.
 */
-(bool)writeToFileHandle:(NSFileHandle *)file error:(NSError **)error {

    uint8_t * buf = malloc_buf(error);
    if (buf == NULL) {
        return false;
    }

    bool result = false;
    @try {
        while (true) {
            NSInteger n = [self read:buf maxLength:BUFSIZE];
            if (n < 0) {
                result = false;
                if (error) {
                    *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil];
                }
                break;
            }
            else if (n == 0) {
                result = true;
                break;
            }
            else {
                [file writeData:[NSData dataWithBytes:buf length:n]];
            }
        }
    }
    @catch (NSException* exn) {
        NSLogWarn(@"Caught exception writing to file: %@", exn);
        result = false;
        if (error) {
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EIO userInfo:nil];
        }
    }

    free(buf);

    return result;
}


/**
 * @return YES on success, NO otherwise with error set.
 */
static BOOL createEmptyFile(NSString * path, NSDataWritingOptions options, NSError * __autoreleasing * error) {
    BOOL sim_failure = false;
#if DEBUG
    TBUserDefaults * ud = [TBUserDefaults userDefaultsForUnauthenticatedUser];
    sim_failure = ud.debugSimulateNSFileProtectionFailures;
#endif
    if (sim_failure) {
        NSError * err = [NSError errorWithDomain:NSPOSIXErrorDomain code:EPERM userInfo:nil];
        if (error != NULL) {
            *error = err;
        }
        return NO;
    }

    return [[NSData data] writeToFile:path options:options error:error];
}


/**
 * @return An open NSFileHandle on success, nil otherwise with errno set.
 */
static NSFileHandle * openFile(NSString * path, NSDataWritingOptions options, NSError * __autoreleasing * error) {
    BOOL ok = createEmptyFile(path, options, error);
    if (!ok) {
        return nil;
    }

    return [NSFileHandle fileHandleForWritingAtPath:path error:error];
}


static uint8_t * malloc_buf(NSError ** error) {
    uint8_t * result = malloc(BUFSIZE);
    if (result == NULL && error) {
        *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:ENOMEM userInfo:nil];
    }
    return result;
}


@end
