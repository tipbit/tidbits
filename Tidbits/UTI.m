//
//  UTI.m
//  Tidbits
//
//  Created by Ewan Mellor on 6/23/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>

#import "NSString+Misc.h"

#import "UTI.h"


BOOL utiConformsTo(NSString * child, NSString * parent) {
    CFStringRef child_ref = (__bridge CFStringRef)child;
    CFStringRef parent_ref = (__bridge CFStringRef)parent;
    return UTTypeConformsTo(child_ref, parent_ref);
}


NSString* utiFilenameToMIME(NSString* fname) {
    if ([fname isNotWhitespace]) {
        NSString * ext = fname.pathExtension;

        // rfc822 is not in the iOS UTI DB, so we treat it specially.
        if ([ext isEqualToString:@"eml"]) {
            return @"message/rfc822";
        }

        CFStringRef pathExtension = (__bridge CFStringRef)ext;
        CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);

        if (type != NULL) {
            NSString* result = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
            CFRelease(type);
            if (result != nil) {
                return result;
            }
        }
    }

    return @"application/octet-stream";
}


static NSString * utiTypeDiscardingDyn(CFStringRef type) {
    if (type == NULL) {
        return nil;
    }

    NSString * type_str = (__bridge_transfer NSString *)type;
    if ([type_str hasPrefix:@"dyn."]) {
        // These are generated on-the-fly when there is no entry in the UTI database.
        // We don't want them, so drop them.
        return nil;
    }

    return type_str;
}


NSString * utiFilenameToType(NSString * filename) {
    if (![filename isNotWhitespace]) {
        return nil;
    }

    CFStringRef pathExtension = (__bridge CFStringRef)filename.pathExtension;
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
    return utiTypeDiscardingDyn(type);
}


NSString* utiMIMEToExtension(NSString* mime) {
    // rfc822 is not in the iOS UTI DB, so we treat it specially.
    if ([mime isEqualToString:@"message/rfc822"]) {
        return @"eml";
    }
    else if ([mime isNotWhitespace]) {
        CFStringRef c_mime = (__bridge CFStringRef)mime;
        CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, c_mime, NULL);

        if (type != NULL) {
            NSString* result = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassFilenameExtension);
            CFRelease(type);
            return result;
        }
    }

    return nil;
}


NSString * utiMIMEToType(NSString * mime) {
    if (![mime isNotWhitespace]) {
        return nil;
    }

    CFStringRef mime_ref = (__bridge CFStringRef)mime;
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mime_ref, NULL);
    return utiTypeDiscardingDyn(type);
}


NSString * utiToMIME(NSString * uti) {
    CFStringRef uti_ref = (__bridge CFStringRef)uti;
    return (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(uti_ref, kUTTagClassMIMEType);
}


NSString * utiHumanReadableDescription(NSString * uti) {
    CFStringRef uti_ref = (__bridge CFStringRef)uti;
    return (__bridge_transfer NSString *)UTTypeCopyDescription(uti_ref);
}


BOOL utiIsImage(NSString * uti) {
    return utiConformsTo(uti, (__bridge NSString *)kUTTypeImage);
}


#pragma mark utiDetectFileTypeAndExtension

static BOOL utiDetectIsPDF(NSData * data) {
    if (data.length < 4) {
        return NO;
    }
    const char * bytes = (const char *)data.bytes;
    return (bytes[0] == '%' &&
            bytes[1] == 'P' &&
            bytes[2] == 'D' &&
            bytes[3] == 'F');
}


extern BOOL utiDetectFileTypeAndExtension(NSData * data, NSString * __autoreleasing * resultExt, NSString * __autoreleasing * resultUti) {
    if (utiDetectIsPDF(data)) {
        if (resultExt != NULL) {
            *resultExt = @"pdf";
        }
        if (resultUti != NULL) {
            *resultUti = (__bridge NSString *)kUTTypePDF;
        }
        return YES;
    }

    return NO;
}
