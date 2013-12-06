//
//  NSInputStream+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 6/15/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "LoggingMacros.h"

#import "NSInputStream+Misc.h"


#define BUFSIZE 4096


@implementation NSInputStream (Misc)

-(NSInteger)readUint32:(uint32_t*)result {
    return readLen(self, (u_int8_t*)result, 4);
}


static NSInteger readLen(NSInputStream* is, u_int8_t* dest, int len) {
    int n = 0;
    while (true) {
        int i = [is read:(dest + n) maxLength:len - n];
        if (i <= 0)
            return i;

        n += i;

        if (n == len)
            return n;
    }
}


-(NSInteger)writeToFile:(NSString *)filepath attributes:(NSDictionary *)attributes {
    NSFileManager* nsfm = [NSFileManager defaultManager];

    NSString* temppath = [filepath stringByAppendingPathExtension:@"tmp"];
    BOOL ok = [nsfm createFileAtPath:temppath contents:nil attributes:attributes];
    if (!ok) {
        NSLog(@"Got error trying to create %@", temppath);
        return -1;
    }

    NSFileHandle* file = [NSFileHandle fileHandleForWritingAtPath:temppath];
    if (file == nil) {
        NSLog(@"Got error trying to open %@", temppath);
        return -1;
    }

    uint8_t* buf = malloc(BUFSIZE);
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
        result = -1;
    }

    [file closeFile];
    free(buf);

    [nsfm removeItemAtPath:filepath error:nil];
    NSError* err = nil;
    ok = [nsfm moveItemAtPath:temppath toPath:filepath error:&err];
    if (!ok || err != nil) {
        NSLog(@"Got error when trying to move %@ to %@: %@", temppath, filepath, err);
        return -1;
    }

    return result;
}


@end
