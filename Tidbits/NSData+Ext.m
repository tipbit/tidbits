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


-(NSURL *)writeToTemporaryFileWithName:(NSString *)filename attributes:(NSDictionary *)attributes error:(NSError **)error __attribute__((nonnull(1))) {
    AssertOnBackgroundThread();
    NSParameterAssert(filename);

    filename = [filename stringBySanitizingFilename];

    NSFileManager * nsfm = [NSFileManager defaultManager];
    NSURL * tempDir = nil;

    NSArray * cacheDirs = [nsfm URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    if (cacheDirs.count == 0) {
        NSLogError(@"Failed to find NSCachesDirectory!  Can't create temporary file for %@.", filename);
        if (error) {
            *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:nil];
        }
        return nil;
    }

    NSURL * cacheDir = cacheDirs[0];
    tempDir = [nsfm URLForDirectory:NSItemReplacementDirectory inDomain:NSUserDomainMask appropriateForURL:cacheDir create:YES error:error];
    if (tempDir == nil) {
        NSLogWarn(@"Error creating temp dir for %@ at %@: %@", filename, cacheDir, *error);
        return nil;
    }

    NSURL* tempFile = [tempDir URLByAppendingPathComponent:filename.lastPathComponent];
    if (tempFile == nil) {
        NSLogError(@"Error creating temp file URL for %@ at %@", filename, tempDir);
        [nsfm removeItemAtURLAsync:tempDir];
        if (error) {
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:ENOMEM userInfo:nil];
        }
        return nil;
    }

    BOOL ok = [nsfm createFileAtPath:tempFile.path contents:self attributes:attributes];
    if (!ok) {
        NSLogWarn(@"Error creating %@", tempFile);
        [nsfm removeItemAtURLAsync:tempDir];
        if (error) {
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil];
        }
        return nil;
    }

    return tempFile;
}


@end


NSDataWritingOptions NSDataWritingOptionForNSFileProtection(NSString * protection) {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    if (protection == NSFileProtectionComplete) {
        return NSDataWritingFileProtectionComplete;
    }
    else if (protection == NSFileProtectionCompleteUnlessOpen) {
        return NSDataWritingFileProtectionCompleteUnlessOpen;
    }
    else if (protection == NSFileProtectionCompleteUntilFirstUserAuthentication) {
        return NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication;
    }
    else if (protection == NSFileProtectionNone) {
        return NSDataWritingFileProtectionNone;
    }
    else if (protection == nil) {
        // Note that NSDataWritingFileProtectionNone is not equal to 0.
        // This means that there's a distinction between NSDataWritingFileProtectionNone
        // and "no file protection specified".
        // I don't know if this distinction is meaningful; it doesn't make any sense to me.
        return (NSDataWritingOptions)0;
    }
    else {
        assert(false);
    }
#else
    return (NSDataWritingOptions)0;
#endif
}
