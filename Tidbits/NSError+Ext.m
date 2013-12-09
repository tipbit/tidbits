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


@end
