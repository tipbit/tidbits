//
//  NSDate+ISO8601.m
//  TBClientLib
//
//  Created by Ewan Mellor on 5/5/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSDate+ISO8601.h"

@implementation NSDate (ISO8601)

#define FORMAT_24 (@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
#define FORMAT_23 (@"yyyy-MM-dd'T'HH:mm:ss.SSS")
#define FORMAT_20 (@"yyyy-MM-dd'T'HH:mm:ss'Z'")
#define FORMAT_19 (@"yyyy-MM-dd'T'HH:mm:ss")
#define FORMAT_10 (@"yyyy-MM-dd")


static NSLocale* posix_locale = nil;
static NSCalendar* gregorian_calendar = nil;
static NSTimeZone* utc_timezone = nil;


+(void)initialize {
    [super initialize];
    posix_locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    gregorian_calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    utc_timezone = [NSTimeZone timeZoneForSecondsFromGMT:0];
}


+(NSDate*) dateFromIso8601:(NSString*)s {
    if (s == nil)
        return nil;
    int len = s.length;
    NSString* format =
        len == 24 ? FORMAT_24 :
        len == 23 ? FORMAT_23 :
        len == 20 ? FORMAT_20 :
        len == 19 ? FORMAT_19 :
        len == 10 ? FORMAT_10 :
                    nil;
    if (format == nil)
        return nil;
    NSDateFormatter* f = makeFormatter(format);
    return [f dateFromString:s];
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
