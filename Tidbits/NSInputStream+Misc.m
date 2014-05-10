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
#import "TBUserDefaults+Tidbits.h"

#import "NSInputStream+Misc.h"


#define BUFSIZE 4096


@implementation NSInputStream (Misc)


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


-(NSData *)writeToFileAndNSData:(NSString *)filepath attributes:(NSDictionary *)attributes length:(NSUInteger)length error:(NSError **)error __attribute__((nonnull(1,2))) {
    NSParameterAssert(filepath);
    NSParameterAssert(attributes);

    NSError * err = nil;
    NSFileManager * nsfm = [NSFileManager defaultManager];
    BOOL ok = [nsfm removeItemAtPath:filepath error:&err];
    if ((!ok || err != nil) && !err.isNoSuchFile) {
        DLog(@"Warning: failed to remove %@: %@.  Ignoring, but this probably will cause the move to fail.", filepath, err);
    }

    NSString * temppath = [filepath stringByAppendingPathExtension:@"tmp"];
    NSFileHandle * file = openFile(temppath, attributes);
    if (file == nil) {
        DLog(@"Cannot open file %@; falling back to just returning the NSData", filepath);
        return [NSData dataWithContentsOfStream:self initialCapacity:length error:error];
    }

    NSData * result;
    ok = [self writeToFileHandle:file error:error];
    if (ok) {
        err = nil;
        ok = [nsfm moveItemAtPath:temppath toPath:filepath error:&err];
        if (!ok || err != nil) {
            NSLog(@"Got error when trying to move %@ to %@: %@.  Just returning the data.", temppath, filepath, err);
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
 * @return YES on success, NO otherwise with errno set.
 */
static BOOL createEmptyFile(NSString * path, NSDictionary * attributes) {
    BOOL sim_failure = false;
#if DEBUG
    TBUserDefaults * ud = [TBUserDefaults userDefaultsForUnauthenticatedUser];
    sim_failure = ud.debugSimulateNSFileProtectionFailures;
#endif
    if (sim_failure) {
        errno = EPERM;
        return NO;
    }
    else {
        NSFileManager* nsfm = [NSFileManager defaultManager];
        return [nsfm createFileAtPath:path contents:nil attributes:attributes];
    }
}


/**
 * @return An open NSFileHandle on success, nil otherwise with errno set.
 */
static NSFileHandle * openFile(NSString * path, NSDictionary * attributes) {
    BOOL ok = createEmptyFile(path, attributes);
    if (!ok) {
        DLog(@"Got error trying to create %@: %s", path, strerror(errno));
        return nil;
    }

    NSFileHandle* file = [NSFileHandle fileHandleForWritingAtPath:path];
    if (file == nil) {
        DLog(@"Got error trying to open %@: %s", path, strerror(errno));
        return nil;
    }

    return file;
}


static uint8_t * malloc_buf(NSError ** error) {
    uint8_t * result = malloc(BUFSIZE);
    if (result == NULL && error) {
        *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:ENOMEM userInfo:nil];
    }
    return result;
}


@end
