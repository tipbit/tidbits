//
//  NSMutableString+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 2/28/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (Misc)

/**
 * If aString is nil, do nothing.  Otherwise, call [self appendString:aString].
 */
-(void)appendStringOrNil:(NSString *)aString;

@end
