//
//  NSDate+ISO8601.m
//  TBClientLib
//
//  Created by Ewan Mellor on 5/5/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "CBLParseDate.h"

#import "NSDate+ISO8601.h"


@implementation NSDate (ISO8601)

#define FORMAT_24 (@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
#define FORMAT_23 (@"yyyy-MM-dd'T'HH:mm:ss.SSS")
#define FORMAT_20 (@"yyyy-MM-dd'T'HH:mm:ss'Z'")
#define FORMAT_19 (@"yyyy-MM-dd'T'HH:mm:ss")
#define FORMAT_16 (@"yyyy-MM-dd'T'HH:mm")
#define FORMAT_10 (@"yyyy-MM-dd")


static NSLocale* posix_locale = nil;
static NSCalendar* gregorian_calendar = nil;
static NSTimeZone* utc_timezone = nil;
static NSTimeInterval k1970ToReferenceDate;


+(void)load {
    posix_locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    gregorian_calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    utc_timezone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    k1970ToReferenceDate = [[NSDate dateWithTimeIntervalSince1970:0.0] timeIntervalSinceReferenceDate];
}


+(NSDate*)dateFromIso8601:(NSString*)s {
    NSTimeInterval t = [self timeIntervalSinceReferenceDateFromIso8601:s];
    return isnan(t) ? nil : [NSDate dateWithTimeIntervalSinceReferenceDate:t];
}
    

+(NSTimeInterval)timeIntervalSinceReferenceDateFromIso8601:(NSString*)s {
    // Note that we truncate to 0.001 (i.e. msec) because CBLParseISO8601Date gives slightly different results compared
    // with NSDateFormatter, and since we know that our dates are always msec precision we can truncate that away.
    return s == nil ? NAN : trunc(1000.0 * (CBLParseISO8601Date(s.UTF8String) + k1970ToReferenceDate)) / 1000.0;
}


+(NSString *)normalizeIso8601_24:(NSString *)s {
    NSUInteger len = [s length];
    return (len == 24 ? s :
            len == 23 ? [NSString stringWithFormat:@"%@Z", s] :
            len == 19 ? [NSString stringWithFormat:@"%@.000Z", s] :
            [[NSDate dateFromIso8601:s] iso8601String_24]);
}


-(NSString*) iso8601String {
    NSDateFormatter* f = makeFormatter(FORMAT_19);
    return [f stringFromDate:self];
}


-(NSString*) iso8601String_16 {
    NSDateFormatter* f = makeFormatter(FORMAT_16);
    return [f stringFromDate:self];
}


-(NSString*) iso8601String_24 {
    NSDateFormatter* f = makeFormatter(FORMAT_24);
    return [f stringFromDate:self];
}


static NSDateFormatter* makeFormatter(NSString* format) {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    f.calendar = gregorian_calendar;
    f.dateFormat = format;
    f.locale = posix_locale;
    f.timeZone = utc_timezone;
    return f;
}


@end
