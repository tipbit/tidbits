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


-(bool)isFileWriteFileExistsError {
    return [self.domain isEqualToString:NSCocoaErrorDomain] && self.code == NSFileWriteFileExistsError;
}


-(bool)isFileWriteNoPermission {
    return [self.domain isEqualToString:NSCocoaErrorDomain] && self.code == NSFileWriteNoPermissionError;
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
    return (([self.domain isEqualToString:NSCocoaErrorDomain] && self.code == NSFileNoSuchFileError) ||
            ([self.domain isEqualToString:NSPOSIXErrorDomain] && self.code == ENOENT));
}

-(bool)isHTTP400 {
    return [self isHTTP:400];
}


-(bool)isHTTP401 {
    return [self isHTTP:401];
}


-(bool)isHTTP403 {
    return [self isHTTP:403];
}


-(bool)isHTTP404 {
    return [self isHTTP:404];
}


-(bool)isHTTP409 {
    return [self isHTTP:409];
}


-(bool)isHTTP422 {
    return [self isHTTP:422];
}


-(bool)isHTTP50x {
    return [self.domain isEqualToString:NSURLErrorDomain] && self.code >= 500 && self.code < 600;
}


-(bool)isHTTP:(NSInteger)code {
    return [self.domain isEqualToString:NSURLErrorDomain] && self.code == code;
}


-(bool)isURLErrorCancelled {
    return [self.domain isEqualToString:NSURLErrorDomain] && self.code == NSURLErrorCancelled;
}


-(NSString *)message {
    return self.userInfo[NSLocalizedDescriptionKey];
}


@end
