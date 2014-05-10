//
//  NSInputStream+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 6/15/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "LoggingMacros.h"
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


-(NSInteger)writeToFile:(NSString *)filepath attributes:(NSDictionary *)attributes {
    NSFileManager* nsfm = [NSFileManager defaultManager];

    NSString* temppath = [filepath stringByAppendingPathExtension:@"tmp"];
    BOOL ok = createEmptyFile(temppath, attributes);
    if (!ok) {
        NSLog(@"Got error trying to create %@: %s", temppath, strerror(errno));
        return -errno;
    }

    NSFileHandle* file = [NSFileHandle fileHandleForWritingAtPath:temppath];
    if (file == nil) {
        NSLog(@"Got error trying to open %@: %s", temppath, strerror(errno));
        return -errno;
    }

    uint8_t* buf = malloc(BUFSIZE);
    if (buf == NULL) {
        [file closeFile];
        return -ENOMEM;
    }

    NSInteger result = 0;
    @try {
        while (true) {
            NSInteger n = [self read:buf maxLength:BUFSIZE];
            if (n < 0) {
                result = n;
                break;
            }
            else if (n == 0) {
                break;
            }
            else {
                [file writeData:[NSData dataWithBytes:buf length:n]];
                result += n;
            }
        }
    }
    @catch (NSException* exn) {
        NSLog(@"Caught exception writing to %@: %@", temppath, exn);
        result = -EIO;
    }

    [file closeFile];
    free(buf);

    NSError* err = nil;
    ok = [nsfm removeItemAtPath:filepath error:&err];
    if ((!ok || err != nil) && !err.isNoSuchFile) {
        NSLog(@"Warning: failed to remove %@: %@.  Ignoring, but this probably will cause the move to fail.", filepath, err);
    }

    err = nil;
    ok = [nsfm moveItemAtPath:temppath toPath:filepath error:&err];
    if (!ok || err != nil) {
        NSLog(@"Got error when trying to move %@ to %@: %@", temppath, filepath, err);
        return -EIO;
    }

    return result;
}


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


@end
