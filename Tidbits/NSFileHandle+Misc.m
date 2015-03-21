//
//  NSFileHandle+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 3/21/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "NSFileHandle+Misc.h"


@implementation NSFileHandle (Misc)


static NSFileHandle * checkForError(NSFileHandle * result, NSError * __autoreleasing * error) {
    if (result == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil];
        }
        return nil;
    }
    else {
        return result;
    }
}


#define fileHandleForXAtPath(__cmd)                                                                         \
+(instancetype)fileHandleFor ## __cmd ## AtPath:(NSString *)path error:(NSError *__autoreleasing *)error {  \
    return checkForError([NSFileHandle fileHandleForReadingAtPath:path], error);                            \
}

fileHandleForXAtPath(Reading)
fileHandleForXAtPath(Updating)
fileHandleForXAtPath(Writing)

#undef fileHandleForXAtPath


@end
