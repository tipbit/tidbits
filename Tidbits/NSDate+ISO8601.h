//
//  NSDate+ISO8601.h
//  TBClientLib
//
//  Created by Ewan Mellor on 5/5/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ISO8601)

+(NSDate*) dateFromIso8601:(NSString*)s;

+(NSString*) normalizeIso8601_24:(NSString*)s;

-(NSString*) iso8601String;
-(NSString*) iso8601String_24;

@end
