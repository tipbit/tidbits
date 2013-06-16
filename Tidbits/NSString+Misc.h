//
//  NSString+Misc.h
//  Tipbit
//
//  Created by Ewan Mellor on 5/23/13.
//  Copyright (c) 2013 Tipbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Misc)

-(bool) contains:(NSString*)substring;

-(bool) endsWithCaseInsensitive:(NSString *)comparand;

-(bool) endsWithChar:(unichar)c;

-(bool) isEqualToStringCaseInsensitive:(NSString*)comparand;

-(bool) startsWith:(NSString *)comparand;

-(bool) startsWithCaseInsensitive:(NSString*)comparand;

-(bool) startsWithChar:(unichar)c;

-(NSString*)trim;

+(NSString*)stringWithUTF8Data:(NSData*)data;

@end
