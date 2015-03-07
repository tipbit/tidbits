//
//  UTI.h
//  Tidbits
//
//  Created by Ewan Mellor on 6/23/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* utiFilenameToMIME(NSString* fname);
extern NSString* utiMIMEToExtension(NSString* mime);
extern NSString * utiToMIME(NSString * uti);
extern NSString * utiHumanReadableDescription(NSString * uti);

/**
 * Detect the type of the given data, using magic numbers or whatever else the file format supports.
 * This only supports PDF at the moment.
 */
extern BOOL utiDetectFileTypeAndExtension(NSData * data, NSString * __autoreleasing * resultExt, NSString * __autoreleasing * resultUti);
