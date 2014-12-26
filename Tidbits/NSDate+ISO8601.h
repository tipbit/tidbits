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
+(NSTimeInterval)timeIntervalSinceReferenceDateFromIso8601:(NSString*)s;

/**
 * @return a 24-character UTC ISO date string (c.f. iso8601String_24).  The value is taken from the given string, and
 * if that is missing the msecs part or Z suffix then those are added.
 */
+(NSString*) normalizeIso8601_24:(NSString*)s;

/**
 * @return A 19-character UTC ISO 8601 date string with seconds but no msec or Z suffix: yyyy-MM-dd'T'HH:mm:ss
 */
-(NSString*) iso8601String;

/**
 * @return A truncated UTC ISO 8601 date string with no seconds part: yyyy-MM-dd'T'HH:mm
 */
-(NSString*) iso8601String_16;

/**
 * @return A full UTC ISO 8601 date string with msec and no timezone suffix: yyyy-MM-dd'T'HH:mm:ss.SSS
 */
-(NSString*) iso8601String_23;

/**
 * @return A full local timezone ISO 8601 date string with msec and no timezone suffix: yyyy-MM-dd'T'HH:mm:ss.SSS
 */
-(NSString*) iso8601String_local_23;

/**
 * @return A full UTC ISO 8601 date string with msec and a Z suffix: yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
 */
-(NSString*) iso8601String_24;

#if DEBUG || RELEASE_TESTING
// Used for performance measurements.
-(NSString*) iso8601String_24_B;
#endif

@end
