//
//  NSDate+Ext.m
//  Tipbit
//
//  Created by Paul on 5/24/13.
//  Copyright (c) 2013 Tipbit. All rights reserved.
//

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIApplication.h>
#endif

#import "NSDate+ISO8601.h"
#import "NSDateFormatter+Misc.h"

#import "NSDate+Ext.h"


#define DAY_IN_SECONDS (60.0 * 60.0 * 24)


@implementation NSDate (Ext)


+(void)load {
    _year1971 = [NSDate dateWithTimeIntervalSince1970:(365 * 24 * 60 * 60)];
    _year2038 = [NSDate dateWithTimeIntervalSince1970:(68.0 * 365 * 24 * 60 * 60)];
    _NSDate_dateComparator = ^NSComparisonResult(NSDate * d1, NSDate * d2) {
        return [d1 compare:d2];
    };
    _NSDate_dateComparatorMsecPrecision = ^NSComparisonResult(NSDate * d1, NSDate * d2) {
        NSTimeInterval diff = d1.timeIntervalSinceReferenceDate - d2.timeIntervalSinceReferenceDate;
        if ((diff > 0.0 && diff < 0.001) ||
            (diff < 0.0 && diff > -0.001)) {
            // Compare using ISO date representations, because that's an easy way to check that these
            // dates are in the same msec, and it avoids the cost of NSDateComponents / NSCalendar.
            NSString * str1 = [d1 iso8601String_23];
            NSString * str2 = [d2 iso8601String_23];
            return [str1 compare:str2];
        }
        else {
            return [d1 compare:d2];
        }
    };
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChange) name:UIApplicationSignificantTimeChangeNotification object:nil];
#endif
}


+(void)significantTimeChange {
    cachedStartOfDayBefore = nil;
    cachedStartOfToday = nil;
    cachedStartOfYesterday = nil;
    cachedStartOf7DaysAgo = nil;
    cachedStartOf30DaysAgo = nil;
    cachedStartOf60DaysAgo = nil;
    cachedStartOfThisMonth = nil;
    cachedThisYear = 0;
}


static NSDate* _year1971 = nil;
+(NSDate *)year1971 {
    return _year1971;
}

static NSDate* _year2038 = nil;
+(NSDate *)year2038 {
    return _year2038;
}


static NSComparator _NSDate_dateComparator = NULL;
+(NSComparator)dateComparator {
    return _NSDate_dateComparator;
}


static NSComparator _NSDate_dateComparatorMsecPrecision = NULL;
+(NSComparator)dateComparatorMsecPrecision {
    return _NSDate_dateComparatorMsecPrecision;
}


- (NSString *) dateAtTimeString {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    NSLocale * locale = [NSLocale autoupdatingCurrentLocale];
    NSString * lang = [locale objectForKey:NSLocaleLanguageCode];
    formatter.dateFormat = ([lang isEqualToString:@"en"] ? @"MMM d, yyyy 'at' h:mm a" :
                                                          [NSDateFormatter dateFormatFromTemplate:@"yyyyMMMd jjm" options:0 locale:locale]);
    return [formatter stringFromDate:self];
}


-(NSString*)userShortDateString {
    NSDateFormatter * formatter = [NSDateFormatter tb_dateShort];
    return [formatter stringFromDate:self];
}


-(NSString*)userYearlessDateString {
    NSDateFormatter * formatter = [NSDateFormatter tb_dateNumeric];
    return [formatter stringFromDate:self];
}


-(NSString*)userYearlessOrShortDateString {
    return self.isThisYear ? self.userYearlessDateString : self.userShortDateString;
}


-(NSString*)userShortTimeString {
    NSDateFormatter* formatter = [NSDateFormatter tb_timeShort];
    NSString* result = [formatter stringFromDate:self];
    return [result lowercaseString];
}


-(NSString*)userYearlessOrShortDateIfNotTodayAndTimeString {
    return self.isToday ? self.userShortTimeString : self.userYearlessOrShortDateAndTimeString;
}


-(NSString*)userYearlessOrShortDateAndTimeString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale autoupdatingCurrentLocale];
    if (self.isThisYear)
        formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"M d" options:0 locale:NSLocale.currentLocale];
    else
        formatter.dateStyle = NSDateFormatterShortStyle;
    NSString* date = [formatter stringFromDate:self];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString* time = [formatter stringFromDate:self];
    return [[NSString stringWithFormat:@"%@ %@", date, time] lowercaseString];
}


-(NSString*)userShortDateAndTimeString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale autoupdatingCurrentLocale];
    formatter.dateStyle = NSDateFormatterShortStyle;
    NSString* date = [formatter stringFromDate:self];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString* time = [formatter stringFromDate:self];
    return [[NSString stringWithFormat:@"%@ %@", date, time] lowercaseString];
}


-(NSString*)userShortTimeOrDateString {
    if ([self isToday])
        return [self userShortTimeString];
    return [self userShortDateString];
}


-(NSString *)userShortTimeDayOrDateString {
    if (self.isToday) {
        return [self userShortTimeString];
    }

    if (self.isYesterday) {
        NSLocale * locale = [NSLocale autoupdatingCurrentLocale];
        NSString * lang = [locale objectForKey:NSLocaleLanguageCode];
        if ([lang isEqualToString:@"en"]) {
            return NSLocalizedString(@"Yesterday", nil);
        }
    }

    if (self.isDayBefore) {
        return self.dayOfWeek;
    }
    return [self userYearlessOrShortDateString];
}


- (NSDate*) startOfDay {
    return [self thisDayAtHour:0 minute:0 second:0 tz:[NSTimeZone systemTimeZone]];
}


- (NSDate*) startOfMonth {
    NSCalendar * cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    cal.timeZone = [NSTimeZone systemTimeZone];
    NSDateComponents * comp = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:self];
    comp.day = 1;
    comp.hour = 0;
    comp.minute = 0;
    comp.second = 0;
    return [cal dateFromComponents:comp];
}

- (NSDate*) startOfNextWeek {
    NSCalendar * cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    cal.timeZone = [NSTimeZone systemTimeZone];
    NSInteger weekdayOfDate = [cal ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfYear forDate:[self startOfDay]];
    NSInteger numberOfDaysToStartOfCurrentWeek = weekdayOfDate - 1;
    NSDateComponents * oneWeek = [[NSDateComponents alloc] init];
    oneWeek.weekOfYear = 1; // add one week
    oneWeek.day = -numberOfDaysToStartOfCurrentWeek; // ... and subtract a couple of days to get the first day of the week
    return [cal dateByAddingComponents:oneWeek toDate:[self startOfDay] options:(NSCalendarOptions)0];
}

- (NSDate*) todayCurrentHour {
    return [self thisDayAtHour:[self currentHour] minute:0 second:0 tz:[NSTimeZone systemTimeZone]];
}

- (NSInteger)currentHour
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:now];
    
    return [components hour];
}


-(NSDate *)startOfMinute {
    NSCalendar * cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    cal.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateComponents * comp = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    comp.second = 0;
    return [cal dateFromComponents:comp];
}


-(NSDate *)endOfMinute {
    NSCalendar * cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    cal.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateComponents * comp = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    comp.second = 59;
    comp.nanosecond = 999000000;
    return [cal dateFromComponents:comp];
}


-(NSDate *)thisDayAtHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second tz:(NSTimeZone *)tz {
    NSCalendar * cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    cal.timeZone = (tz == nil ? [NSTimeZone timeZoneWithName:@"UTC"] : tz);
    NSDateComponents * comp = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    comp.hour = hour;
    comp.minute = minute;
    comp.second = second;
    return [cal dateFromComponents:comp];
}


- (BOOL) isBefore:(NSDate*)date {
    return [self compare:date] == NSOrderedAscending;
}

- (BOOL) isAfter:(NSDate*)date {
    return [self compare:date] == NSOrderedDescending;
}


-(BOOL)isStartOfHour {
    NSCalendar * cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    cal.timeZone = [NSTimeZone systemTimeZone];
    NSDateComponents * comp = [cal components:(NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
    return comp.minute == 0 && comp.second == 0;
}


-(BOOL)isSameDayAs:(NSDate *)date {
    NSCalendar * cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    cal.timeZone = [NSTimeZone systemTimeZone];

    NSCalendarUnit units = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents * compSelf = [cal components:units fromDate:self];
    NSDateComponents * compOther = [cal components:units fromDate:date];

    return (compSelf.year == compOther.year && compSelf.month == compOther.month && compSelf.day == compOther.day);
}


-(BOOL)isSameUTCDayAs:(NSDate *)date {
    time_t self_time_t = (time_t)[self timeIntervalSince1970];
    time_t date_time_t = (time_t)[date timeIntervalSince1970];
    struct tm self_tm;
    struct tm date_tm;
    gmtime_r(&self_time_t, &self_tm);
    gmtime_r(&date_time_t, &date_tm);
    return (self_tm.tm_yday == date_tm.tm_yday && self_tm.tm_year == date_tm.tm_year);
}


static NSDate* cachedStartOfToday = nil;
+(NSDate*) startOfToday {
    if (cachedStartOfToday == nil)
        cachedStartOfToday = [[NSDate date] startOfDay];
    return cachedStartOfToday;
}


static NSDate* cachedStartOfYesterday = nil;
+(NSDate*) startOfYesterday {
    if (cachedStartOfYesterday == nil)
        cachedStartOfYesterday = [[NSDate startOfToday] dateByAddingTimeInterval:-DAY_IN_SECONDS];
    return cachedStartOfYesterday;
}


static NSDate* cachedStartOfDayBefore = nil;
+ (NSDate*) startOfDayBefore {
    if (cachedStartOfDayBefore == nil)
        cachedStartOfDayBefore = [[NSDate startOfToday] dateByAddingTimeInterval:-DAY_IN_SECONDS * 2];
    return cachedStartOfDayBefore;
}


static NSDate* cachedStartOf7DaysAgo = nil;
+(NSDate*)startOf7DaysAgo {
    if (cachedStartOf7DaysAgo == nil)
        cachedStartOf7DaysAgo = [[NSDate startOfToday] dateByAddingTimeInterval:-DAY_IN_SECONDS * 7];
    return cachedStartOf7DaysAgo;
}


static NSDate* cachedStartOf30DaysAgo = nil;
+(NSDate*)startOf30DaysAgo {
    if (cachedStartOf30DaysAgo == nil)
        cachedStartOf30DaysAgo = [[NSDate startOfToday] dateByAddingTimeInterval:-DAY_IN_SECONDS * 30];
    return cachedStartOf30DaysAgo;
}


static NSDate* cachedStartOf60DaysAgo = nil;
+(NSDate*)startOf60DaysAgo {
    if (cachedStartOf60DaysAgo == nil)
        cachedStartOf60DaysAgo = [[NSDate startOfToday] dateByAddingTimeInterval:-DAY_IN_SECONDS * 60];
    return cachedStartOf60DaysAgo;
}

+(NSDate*) startOfNextWeek {
    return [[NSDate date] startOfNextWeek];
}

static NSDate* cachedStartOfThisMonth = nil;
+(NSDate*) startOfThisMonth {
    if (cachedStartOfThisMonth == nil)
        cachedStartOfThisMonth = [[NSDate date] startOfMonth];
    return cachedStartOfThisMonth;
}


- (BOOL) isToday {
    return [self isSameDayAs:[NSDate startOfToday]];
}

-(BOOL) isYesterday {
    return [self isSameDayAs:[NSDate startOfYesterday]];
}

-(BOOL) isDayBefore {
    return [self isSameDayAs:[NSDate startOfDayBefore]];
}

static NSInteger cachedThisYear = 0;
-(BOOL) isThisYear {
    NSCalendar * cal = [NSCalendar currentCalendar];

    if (cachedThisYear == 0) {
        NSDate * today = [NSDate date];
        NSDateComponents * today_bits = [cal components:NSCalendarUnitYear fromDate:today];
        cachedThisYear = today_bits.year;
    }

    NSDateComponents * date_bits = [cal components:NSCalendarUnitYear fromDate:self];
    return (cachedThisYear == date_bits.year);
}


-(NSString*) dayOfWeek {
    NSDateFormatter *formatter = [NSDateFormatter tb_dayOfWeekFull];
    return [formatter stringFromDate:self];
}


-(NSDate *)dateByFixingTwoDigitYears {
    NSTimeInterval ti = self.timeIntervalSinceReferenceDate;

    // Magic constants in the if statements are as below.
    //   NSTimeInterval year50 = [[NSDate dateFromIso8601:@"0050-01-01T00:00:00Z"] timeIntervalSinceReferenceDate];
    const NSTimeInterval year50 = -61567603200.0;
    //   NSTimeInterval year100 = [[NSDate dateFromIso8601:@"0100-01-01T00:00:00Z"] timeIntervalSinceReferenceDate];
    const NSTimeInterval year100 = -59989766400.0;
    //   NSDate * year1 = [NSDate dateFromIso8601:@"0001-01-01T00:00:00Z"];
    //   NSDate * year2001 = [NSDate dateFromIso8601:@"2001-01-01T00:00:00Z"];
    //   NSTimeInterval delta2000 = year2001.timeIntervalSinceReferenceDate - year1.timeIntervalSinceReferenceDate;
    const NSTimeInterval delta2000 = 63113904000.0;
    //   NSDate * year51 = [NSDate dateFromIso8601:@"0051-01-01T00:00:00Z"];
    //   NSDate * year1951 = [NSDate dateFromIso8601:@"1951-01-01T00:00:00Z"];
    //   NSTimeInterval y1900delta = year1951.timeIntervalSinceReferenceDate - year51.timeIntervalSinceReferenceDate;
    const NSTimeInterval delta1900 = 59958144000.0;
    if (ti < year50) {
        // Before 50 AD.  Assume that this is actually a two digit date that's meant to be 20xx.
        return [self dateByAddingTimeInterval:delta2000];
    }
    else if (ti < year100) {
        // Before 100 AD.  Assume that this is actually a two digit date that's meant to be 19xx.
        return [self dateByAddingTimeInterval:delta1900];
    }
    else {
        return self;
    }
}


+(NSTimeInterval)timeIntervalFromDays:(NSInteger)days
{
    return [self timeIntervalFromDays:days hours:0 minutes:0 seconds:0];
}

+(NSTimeInterval)timeIntervalFromHours:(NSInteger)hours
{
    return [self timeIntervalFromDays:0 hours:hours minutes:0 seconds:0];
}

+(NSTimeInterval)timeIntervalFromMinutes:(NSInteger)minutes
{
    return [self timeIntervalFromDays:0 hours:0 minutes:minutes seconds:0];
}

+(NSTimeInterval)timeIntervalFromDays:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds
{
    return (days * 24 * 3600) + (hours * 3600) + (minutes * 60) + seconds;
}


+(NSDate *)dateFromHHMMA:(NSString *)hhmma {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    dateFormatter.calendar = calendar;
    dateFormatter.dateFormat = @"hh:mm a";
    return [dateFormatter dateFromString:hhmma];
}


+(NSTimeInterval)timeIntervalFromHHMMA:(NSString *)hhmma {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    NSDate * start = [dateFormatter dateFromString:@"00:00 am"];
    NSDate * end = [dateFormatter dateFromString:hhmma];
    return [end timeIntervalSinceDate:start];
}


+(NSTimeInterval)timeIntervalFromHHMM:(NSString *)hhmm {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    NSDate * start = [dateFormatter dateFromString:@"00:00"];
    NSDate * end = [dateFormatter dateFromString:hhmm];
    return [end timeIntervalSinceDate:start];
}


+(NSString *)stringFromHHMMA:(NSDate *)hhmma {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    dateFormatter.calendar = calendar;
    dateFormatter.dateFormat = @"h:mm a";
    return [dateFormatter stringFromDate:hhmma];
}


+(NSString *)stringFromHHMM:(NSDate *)hhmm {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    return [dateFormatter stringFromDate:hhmm];
}


+(NSTimeInterval)timeIntervalRoundedTo5Minutes:(NSTimeInterval)ti
{
    int remainingSeconds = (int)ti % 300;
    NSTimeInterval timeIntervalRoundedTo5Minutes = ti - remainingSeconds;
    if(remainingSeconds>150)
        timeIntervalRoundedTo5Minutes = ti +(300-remainingSeconds);
    return timeIntervalRoundedTo5Minutes;
}


@end
