//
//  UTI.h
//  Tidbits
//
//  Created by Ewan Mellor on 6/23/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @return YES if the given child UTI conforms to the given parent UTI.
 * See UTTypeConformsTo for the definition of "conforms to".
 */
extern BOOL utiConformsTo(NSString * child, NSString * parent);

/**
 * @return The MIME type corresponding to the given filename (its extension, specifically).
 * "message/rfc822" for .eml files (even though that's not in the UTI database).
 * "application/octet-stream" if there's no match in the UTI database (so this function will
 * never return nil).
 */
extern NSString * utiFilenameToMIME(NSString* fname);

/**
 * @return The UTI type corresponding to the given filename (its extension, specifically) or nil if
 * the given filename is empty or there's no match in the UTI database.
 */
extern NSString * utiFilenameToType(NSString * filename);

/**
 * @return The human-readable description corresponding to the given UTI
 * or nil if there's no match in the UTI database.
 */
extern NSString * utiHumanReadableDescription(NSString * uti);

/**
 * @return YES if the given UTI is an image (i.e. it conforms to public.image).
 */
extern BOOL utiIsImage(NSString * uti);

/**
 * @return The file extension corresponding to the given MIME type.
 * "eml" for message/rfc822 (even though that's not in the UTI database).
 * nil if there's no match in the UTI database.
 */
extern NSString * utiMIMEToExtension(NSString* mime);

/**
 * @return The UTI type corresponding to the given MIME type or nil if there's no match in the UTI database.
 */
extern NSString * utiMIMEToType(NSString * mime);

/**
 * @return The MIME type corresponding to the given UTI type or nil if there's no match in the UTI database.
 */
extern NSString * utiToMIME(NSString * uti);

/**
 * Detect the type of the given data, using magic numbers or whatever else the file format supports.
 * This only supports PDF at the moment.
 */
extern BOOL utiDetectFileTypeAndExtension(NSData * data, NSString * __autoreleasing * resultExt, NSString * __autoreleasing * resultUti);
