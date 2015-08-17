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

#define FORMAT_24 "%4d-%02d-%02dT%02d:%02d:%02d.%03dZ"
#define FORMAT_23 "%4d-%02d-%02dT%02d:%02d:%02d.%03d"
#define FORMAT_20 "%4d-%02d-%02dT%02d:%02d:%02dZ"
#define FORMAT_19 "%4d-%02d-%02dT%02d:%02d:%02d"
#define FORMAT_16 "%4d-%02d-%02dT%02d:%02d"


static NSTimeInterval k1970ToReferenceDate;


+(void)load {
    k1970ToReferenceDate = [[NSDate dateWithTimeIntervalSince1970:0.0] timeIntervalSinceReferenceDate];
}


+(NSDate*)dateFromIso8601:(NSString*)s {
    NSTimeInterval t = [self timeIntervalSinceReferenceDateFromIso8601:s];
    return isnan(t) ? nil : [NSDate dateWithTimeIntervalSinceReferenceDate:t];
}
    

+(NSTimeInterval)timeIntervalSinceReferenceDateFromIso8601:(NSString*)s {
    // Note that we round to 0.001 (i.e. msec) because CBLParseISO8601Date gives slightly different results compared
    // with NSDateFormatter, and since we know that our dates are always msec precision we can truncate that away.
    return s == nil ? NAN : round(1000.0 * (CBLParseISO8601Date(s.UTF8String) + k1970ToReferenceDate)) / 1000.0;
}


+(NSString *)normalizeIso8601_24:(NSString *)s {
    NSUInteger len = [s length];
    return (len == 24 ? s :
            len == 23 ? [NSString stringWithFormat:@"%@Z", s] :
            len == 19 ? [NSString stringWithFormat:@"%@.000Z", s] :
            [[NSDate dateFromIso8601:s] iso8601String_24]);
}


-(NSString*) iso8601String {
    // This implementation and the similar ones below are 10x faster than using NSDateFormatter.
    struct tm tm;
    gmtime_of_interval([self timeIntervalSince1970], &tm);
    char buf[20];
    snprintf(buf, sizeof(buf), FORMAT_19, tm.tm_year + 1900, tm.tm_mon + 1,
             tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec);
    return [NSString stringWithCString:buf encoding:NSASCIIStringEncoding];
}


-(NSString*) iso8601String_16 {
    struct tm tm;
    gmtime_of_interval([self timeIntervalSince1970], &tm);
    char buf[17];
    snprintf(buf, sizeof(buf), FORMAT_16, tm.tm_year + 1900, tm.tm_mon + 1,
             tm.tm_mday, tm.tm_hour, tm.tm_min);
    return [NSString stringWithCString:buf encoding:NSASCIIStringEncoding];
}


-(NSString*) iso8601String_23 {
    struct tm tm;
    int ts_frac = gmtime_and_msec_of_interval([self timeIntervalSince1970], &tm);
    char buf[24];
    snprintf(buf, sizeof(buf), FORMAT_23, tm.tm_year + 1900, tm.tm_mon + 1,
             tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec, ts_frac);
    return [NSString stringWithCString:buf encoding:NSASCIIStringEncoding];
}


-(NSString*) iso8601String_local_23 {
    struct tm tm;
    int ts_frac = localtime_and_msec_of_interval([self timeIntervalSince1970], &tm);
    char buf[24];
    snprintf(buf, sizeof(buf), FORMAT_23, tm.tm_year + 1900, tm.tm_mon + 1,
             tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec, ts_frac);
    return [NSString stringWithCString:buf encoding:NSASCIIStringEncoding];
}


-(NSString*) iso8601String_24 {
    struct tm tm;
    int ts_frac = gmtime_and_msec_of_interval([self timeIntervalSince1970], &tm);
    char buf[25];
    snprintf(buf, sizeof(buf), FORMAT_24, tm.tm_year + 1900, tm.tm_mon + 1,
             tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec, ts_frac);
    return [NSString stringWithCString:buf encoding:NSASCIIStringEncoding];
}


static void gmtime_of_interval(NSTimeInterval ts, struct tm * tm) {
    time_t ts_whole = (time_t)ts;
    gmtime_r(&ts_whole, tm);
}


static int localtime_and_msec_of_interval(NSTimeInterval ts, struct tm * tm) {
    time_t ts_whole = (time_t)ts;
    localtime_r(&ts_whole, tm);
    return (int)round((ts - (double)ts_whole) * 1000.0);
}


static int gmtime_and_msec_of_interval(NSTimeInterval ts, struct tm * tm) {
    time_t ts_whole = (time_t)ts;
    gmtime_r(&ts_whole, tm);
    return (int)round((ts - (double)ts_whole) * 1000.0);
}


#if DEBUG || RELEASE_TESTING

-(NSString *)iso8601String_24_B {
    return [self iso8601String_24];
}

#endif


@end
