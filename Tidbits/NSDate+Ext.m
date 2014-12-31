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

#import "NSDate+Ext.h"
#import "NSDate+ISO8601.h"


#define DAY_IN_SECONDS (60.0 * 60.0 * 24)


@implementation NSDate (Ext)


+(void)load {
    _year2038 = [NSDate dateWithTimeIntervalSince1970:(68.0 * 365 * 24 * 60 * 60)];
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


static NSDate* _year2038 = nil;
+(NSDate *)year2038 {
    return _year2038;
}


- (NSString *) dateAtTimeString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM d, yyyy 'at' h:mm a";
    return [formatter stringFromDate:self];;
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


-(NSString*)userYearlessOrShortDateString {
    return self.isThisYear ? self.userYearlessDateString : self.userShortDateString;
}


-(NSString*)userShortTimeString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString* result = [formatter stringFromDate:self];
    return [result lowercaseString];
}


-(NSString*)userYearlessOrShortDateIfNotTodayAndTimeString {
    return self.isToday ? self.userShortTimeString : self.userYearlessOrShortDateAndTimeString;
}


-(NSString*)userYearlessOrShortDateAndTimeString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
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
    if ([self isToday])
        return [self userShortTimeString];
    if ([self isYesterday])
        return @"Yesterday";
    if ([self isDayBefore])
        return [self dayOfWeek];
    return [self userYearlessOrShortDateString];
}


- (NSDate*) startOfDay {
    return [self thisDayAtHour:0 minute:0 second:0 tz:[NSTimeZone systemTimeZone]];
}


- (NSDate*) startOfMonth {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents * comp = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:self];
    [comp setDay:1];
    [comp setHour:0];
    [comp setMinute:0];
    [comp setSecond:0];
    return [cal dateFromComponents:comp];
}

- (NSDate*) startOfNextWeek {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger weekdayOfDate = [cal ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:[self startOfDay]];
    NSInteger numberOfDaysToStartOfCurrentWeek = weekdayOfDate - 1;
    NSDateComponents *oneWeek = [[NSDateComponents alloc] init];
    [oneWeek setWeekOfYear:1]; // add one week
    [oneWeek setDay:-numberOfDaysToStartOfCurrentWeek]; // ... and subtract a couple of days to get the first day of the week
    NSDate *startOfNextWeek = [cal dateByAddingComponents:oneWeek toDate:[self startOfDay] options:0];
    return startOfNextWeek;
}

- (NSDate*) todayCurrentHour {
    return [self thisDayAtHour:[self currentHour] minute:0 second:0 tz:[NSTimeZone systemTimeZone]];
}

- (NSInteger)currentHour
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
    
    return [components hour];
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
        NSDate *today = [NSDate date];
        NSDateComponents *today_bits = [cal components:NSYearCalendarUnit fromDate:today];
        cachedThisYear = today_bits.year;
    }

    NSDateComponents *date_bits = [cal components:NSYearCalendarUnit fromDate:self];
    return cachedThisYear == date_bits.year;
}


-(NSString*) dayOfWeek {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEEE";
    return [formatter stringFromDate:self];
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

+(NSDate *)dateFromHHMMA:(NSString *)hhmma
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [dateFormatter setCalendar:calendar];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSDate *date = [dateFormatter dateFromString:hhmma];
    return date;
}
+(NSTimeInterval)timeIntervalFromHHMMA:(NSString *)hhmma
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSDate *start = [dateFormatter dateFromString:@"00:00 am"];
    NSDate *end = [dateFormatter dateFromString:hhmma];
    NSTimeInterval interval = [end timeIntervalSinceDate:start];
    return interval;
}

+(NSTimeInterval)timeIntervalFromHHMM:(NSString *)hhmm
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *start = [dateFormatter dateFromString:@"00:00"];
    NSDate *end = [dateFormatter dateFromString:hhmm];
    NSTimeInterval interval = [end timeIntervalSinceDate:start];
    return interval;
}
+(NSString *)stringFromHHMMA:(NSDate *)hhmma
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [dateFormatter setCalendar:calendar];
    [dateFormatter setDateFormat:@"h:mm a"];
    NSString *value = [dateFormatter stringFromDate:hhmma];
    return value;
}

+(NSString *)stringFromHHMM:(NSDate *)hhmm
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *value = [dateFormatter stringFromDate:hhmm];
    return value;
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
