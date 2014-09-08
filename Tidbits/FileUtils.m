//
//  FileUtils.m
//  Tidbits
//
//  Created by Ewan Mellor on 7/6/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "Dispatch.h"
#import "LoggingMacros.h"
#import "NSError+Ext.h"

#import "FileUtils.h"

@implementation FileUtils


+(void)asyncReadFile:(NSString*)path fileFound:(NSDataBlock)fileFound fileNotFound:(VoidBlock)fileNotFound {
    dispatchAsyncBackgroundThread(DISPATCH_QUEUE_PRIORITY_DEFAULT, ^{
        NSFileManager* nsfm = [NSFileManager defaultManager];
        if ([nsfm fileExistsAtPath:path]) {
            NSError* err = nil;
            NSData* data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&err];
            if (data == nil || err != nil) {
                NSLogError(@"Failed to read data from file %@: %@", path, err);
                fileNotFound();
            }
            else {
                fileFound(data);
            }
        }
        else {
            fileNotFound();
        }
    });
}


+(void)asyncWriteFile:(NSString*)path data:(NSData*)data onSuccess:(VoidBlock)onSuccess onFailure:(NSErrorBlock)onFailure {
    dispatchAsyncBackgroundThread(DISPATCH_QUEUE_PRIORITY_DEFAULT, ^{
        NSString* dir = [path stringByDeletingLastPathComponent];

        NSFileManager* fm = [NSFileManager defaultManager];
        NSError* err = nil;
        BOOL ok = [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&err];
        if (!ok) {
            if (errIsUnusual(err)) {
                NSLogError(@"Failed to create directory %@ for write of %@: %@", dir, path, err);
            }
            onFailure(err);
            return;
        }

        err = nil;
        ok = [data writeToFile:path options:NSDataWritingAtomic error:&err];
        if (ok) {
            onSuccess();
        }
        else {
            if (errIsUnusual(err)) {
                NSLogError(@"Failed to write data to file %@: %@", path, err);
            }
            onFailure(err);
        }
    });
}


static bool errIsUnusual(NSError * err) {
    if (err.isFileWriteNoPermission) {
        // Screen is locked.  Happens all the time.
        return false;
    }
    return true;
}


+(void)asyncWriteFileIfDataSet:(NSString*)path data:(NSData*)data onSuccess:(VoidBlock)onSuccess onFailure:(NSErrorBlock)onFailure {
    if (data == nil)
        onSuccess();
    else
        [FileUtils asyncWriteFile:path data:data onSuccess:onSuccess onFailure:onFailure];
}


@end
