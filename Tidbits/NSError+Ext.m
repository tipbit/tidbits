//
//  NSError+Ext.m
//  Tidbits
//
//  Created by Ewan Mellor on 12/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSError+Ext.h"

@implementation NSError (Ext)


-(bool)isNoSuchFile {
    return ((self.domain == NSCocoaErrorDomain && self.code == NSFileNoSuchFileError) ||
            (self.domain == NSPOSIXErrorDomain && self.code == ENOENT));
}

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)message
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    details[NSLocalizedDescriptionKey] = message;
    return [NSError errorWithDomain:domain code:code userInfo:details];
}

- (NSString *)message
{
    return self.userInfo[NSLocalizedDescriptionKey];
}

@end
