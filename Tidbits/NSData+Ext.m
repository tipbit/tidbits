//
//  NSData+Ext.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/7/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "LoggingMacros.h"
#import "NSFileManager+Ext.h"
#import "NSString+Misc.h"
#import "TBAsserts.h"

#import "NSData+Ext.h"


@implementation NSData (Ext)


-(void)writeToTemporaryFileWithName:(NSString*)filename onSuccess:(NSURLBlock)onSuccess onFailure:(NSErrorBlock)onFailure __attribute__((nonnull(1))) {
    AssertOnBackgroundThread();
    NSParameterAssert(filename);

    filename = [filename stringBySanitizingFilename];

    NSFileManager* nsfm = [NSFileManager defaultManager];
    __block NSURL* tempDir = nil;

    NSErrorBlock myOnFailure = ^(NSError* err) {
        if (tempDir)
            [[NSFileManager defaultManager] removeItemAtURLAsync:tempDir];

        if (onFailure)
            onFailure(err);
    };

    NSArray *cacheDirs = [nsfm URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    if (cacheDirs.count == 0) {
        NSLog(@"Failed to find NSCachesDirectory!  Can't create temporary file for %@.", filename);
        NSError* err2 = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:nil];
        myOnFailure(err2);
        return;
    }

    NSError* err = nil;
    NSURL *cacheDir = cacheDirs[0];
    tempDir = [nsfm URLForDirectory:NSItemReplacementDirectory inDomain:NSUserDomainMask appropriateForURL:cacheDir create:YES error:&err];
    if (tempDir == nil) {
        NSLog(@"Error creating temp dir for %@ at %@: %@", filename, cacheDir, err);
        myOnFailure(err);
        return;
    }

    NSURL* tempFile = [tempDir URLByAppendingPathComponent:filename.lastPathComponent];
    if (tempFile == nil) {
        NSLog(@"Error creating temp file URL for %@ at %@", filename, tempDir);
        NSError* err2 = [NSError errorWithDomain:NSPOSIXErrorDomain code:ENOMEM userInfo:nil];
        myOnFailure(err2);
        return;
    }

    BOOL ok = [nsfm createFileAtPath:tempFile.path contents:self attributes:@{NSFileProtectionKey: NSFileProtectionComplete}];
    if (!ok) {
        NSLog(@"Error creating %@", tempFile);
        NSError* err2 = [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil];
        myOnFailure(err2);
        return;
    }

    if (onSuccess)
        onSuccess(tempFile);
}


@end
