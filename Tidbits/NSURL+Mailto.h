//
//  NSURL+Mailto.h
//  Tidbits
//
//  Created by Ewan Mellor on 2/2/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * RFC 6808.
 */
@interface NSURL (Mailto)

/**
 * @param resultTo Will be filled with an NSString array, the specified To: addresses.  These have been decoded appropriately (percent and UTF-8) and encoded appropriately (Punycode).  May be NULL.
 * May be filled with nil.
 * @param subject Will be filled with the specified subject, if any.  This has been decoded using percent and UTF-8 decoding, but has
 * not been decoded using RFC 2047 (MIME encoded words).  The caller is responsible for RFC 2047 decoding / transcoding.  May be NULL.  May be filled with nil.
 * @param body Will be filled with the specified body, if any.  This has been decoded using percent and UTF-8 decoding, but has
 * not been decoded using RFC 2047 (MIME encoded words).  The caller is responsible for RFC 2047 decoding / transcoding.  May be NULL.  May be filled with nil.
 */
-(void)parseMailtoReturningTo:(NSArray * __autoreleasing *)resultTo subject:(NSString * __autoreleasing *)resultSubject body:(NSString * __autoreleasing *)resultBody;

@end
