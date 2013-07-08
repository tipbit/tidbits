//
//  UTI.m
//  Tidbits
//
//  Created by Ewan Mellor on 6/23/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>

#import "NSString+IsNotWhitespace.h"

#import "UTI.h"


NSString* utiFilenameToMIME(NSString* fname) {
    if ([fname isNotWhitespace]) {
        CFStringRef pathExtension = (__bridge_retained CFStringRef)[fname pathExtension];
        CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
        CFRelease(pathExtension);

        if (type != NULL) {
            NSString* result = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
            CFRelease(type);
            return result;
        }
    }

    return @"application/octet-stream";
}


NSString* utiMIMEToExtension(NSString* mime) {
    if ([mime isNotWhitespace]) {
        CFStringRef c_mime = (__bridge_retained CFStringRef)mime;
        CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, c_mime, NULL);
        CFRelease(c_mime);

        if (type != NULL) {
            NSString* result = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassFilenameExtension);
            CFRelease(type);
            return result;
        }
    }

    return nil;
}