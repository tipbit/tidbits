//
//  NSError+Ext.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSError+Ext.h"

@implementation NSError (Ext)


+(id)errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)message {
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    details[NSLocalizedDescriptionKey] = message;
    return [NSError errorWithDomain:domain code:code userInfo:details];
}


-(bool)isFileWriteNoPermission {
    return self.domain == NSCocoaErrorDomain && self.code == NSFileWriteNoPermissionError;
}


-(bool)isNetworkError {
    if ([self.domain isEqualToString:NSURLErrorDomain]) {
        switch (self.code) {
            case NSURLErrorTimedOut:
            case NSURLErrorCannotFindHost:
            case NSURLErrorCannotConnectToHost:
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorDNSLookupFailed:
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorInternationalRoamingOff:
            case NSURLErrorCallIsActive:
            case NSURLErrorDataNotAllowed:
                return true;

            default:
                return false;
        }
    }

    return false;
}


-(bool)isNoSuchFile {
    return ((self.domain == NSCocoaErrorDomain && self.code == NSFileNoSuchFileError) ||
            (self.domain == NSPOSIXErrorDomain && self.code == ENOENT));
}


-(NSString *)message {
    return self.userInfo[NSLocalizedDescriptionKey];
}


@end
