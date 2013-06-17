//
//  NSDate+Ext.m
//  Tipbit
//
//  Created by Paul on 5/24/13.
//  Copyright (c) 2013 Tipbit. All rights reserved.
//

#import "NSDate+Ext.h"

@implementation NSDate (Ext)


+(NSDate *)year2038 {
    return [NSDate dateWithTimeIntervalSince1970:(68.0 * 365 * 24 * 60 * 60)];
}


+ (NSDate*) dateFromServerString:(NSString*)dateStr {
    if ([dateStr rangeOfString:@"Z"].location != NSNotFound)
        dateStr = [dateStr substringToIndex:19];

    return [makeISO8601Formatter() dateFromString:dateStr];
}


-(NSString*)serverString {
    NSString *s = [makeISO8601Formatter() stringFromDate:self];
    return [s stringByReplacingOccurrencesOfString:@"Z" withString:@""];
}


static NSDateFormatter* makeISO8601Formatter() {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];

    formatter.locale = enUSPOSIXLocale;
    formatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];

    return formatter;
}


-(NSString*)userShortDateString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    return [formatter stringFromDate:self];
}


-(NSString*)userYearlessDateString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"M d" options:0 locale:NSLocale.currentLocale];
    return [formatter stringFromDate:self];
}


-(NSString*)userShortTimeString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString* result = [formatter stringFromDate:self];
    return [result lowercaseString];
}


- (NSDate*) startOfDay {
    return [self thisDayAtHour:0 minute:0 second:0 tz:[NSTimeZone systemTimeZone]];
}


- (NSDate*) thisDayAtHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second tz:(NSTimeZone*)tz {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    if (tz == nil)
        tz = [NSTimeZone timeZoneWithName:@"UTC"];
    [cal setTimeZone:tz];
    NSDateComponents * comp = [cal components:( NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:self];
    [comp setHour:hour];
    [comp setMinute:minute];
    [comp setSecond:second];
    return [cal dateFromComponents:comp];
}


- (BOOL) isBefore:(NSDate*)date {
    return [self compare:date] == NSOrderedAscending;
}

- (BOOL) isAfter:(NSDate*)date {
    return [self compare:date] == NSOrderedDescending;
}

- (BOOL) isSameDayAs:(NSDate*)date {

    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setTimeZone:[NSTimeZone systemTimeZone]];

    NSDateComponents *compSelf = [cal components:( NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];

    NSDateComponents *compOther = [cal components:( NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];

    return compSelf.year==compOther.year && compSelf.month==compOther.month && compSelf.day==compOther.day;
}

- (BOOL) isToday {
    return [self isSameDayAs:[NSDate date]];
}

#define DAY_IN_SECONDS (60.0 * 60.0 * 24)

-(BOOL) isYesterday {
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-DAY_IN_SECONDS];
    return [self isSameDayAs:yesterday];

}

-(BOOL) isDayBefore {
    NSDate *before = [NSDate dateWithTimeIntervalSinceNow:-DAY_IN_SECONDS*2];
    return [self isSameDayAs:before];
}

-(BOOL) isThisYear {
    NSDate *today = [NSDate date];
    NSDateComponents *today_bits = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:today];
    NSDateComponents *date_bits = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];

    return today_bits.year == date_bits.year;
}


-(NSString*) dayOfWeek {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEEE";
    return [formatter stringFromDate:self];
}


@end
