//
//  NSRegularExpression+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 1/26/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRegularExpression (Misc)

/**
 * @return An NSRegularExpression that will find the given wordPrefix after a word boundary.
 * The regular expression options are set to
 * NSRegularExpressionCaseInsensitive | NSRegularExpressionUseUnicodeWordBoundaries.
 * If wordPrefix is nil or empty, nil is returned.
 */
+(instancetype)wordPrefixCaseInsensitive:(NSString *)wordPrefix;

@end
