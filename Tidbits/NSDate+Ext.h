//
//  NSDate+Ext.h
//  Tipbit
//
//  Created by Paul on 5/24/13.
//  Copyright (c) 2013 Tipbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Ext)

+(NSDate*)year2038;

-(NSString*) dateAtTimeString;
-(NSString*)userShortDateString;
-(NSString*)userShortDateAndTimeString;
-(NSString*)userYearlessDateString;
-(NSString*)userShortTimeString;
-(NSString*)userShortTimeDayOrDateString;

/**
 * Equivalent to `self.isThisYear ? self.userYearlessDateString : userShortDateString`.
 */
-(NSString*)userYearlessOrShortDateString;

/**
 * Equivalent to `self.userYearlessOrShortDateString` and `self.userShortTimeString`, separated by a space.
 */
-(NSString*)userYearlessOrShortDateAndTimeString;

/**
 * Equivalent to `self.isToday ? self.usershortTimeString : self.userYearlessOrShortDateAndTimeString`.
 */
-(NSString*)userYearlessOrShortDateIfNotTodayAndTimeString;

/**
 * Equivalent to `[self thisDayAtHour:0 minute:0 second:0 tz:[NSTimeZone systemTimeZone]`.
 */
- (NSDate*) startOfDay;

/*!
 @abstract Now with minutes and seconds zeroed. Equivalent to [self thisDayAtHour:14 minute:0 second:0 tz:[NSTimeZone systemTimeZone] where the current time is >= 2pm < 3pm
 */
- (NSDate*) todayCurrentHour;


/*!
 @abstract Returns a new NSDate that is on the same day as this one, but at the specified time.
 @param tz May be nil, in which case UTC is used.
 */
- (NSDate*) thisDayAtHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second tz:(NSTimeZone*)tz;


- (BOOL) isBefore:(NSDate*)date;
- (BOOL) isAfter:(NSDate*)date;
- (BOOL) isSameDayAs:(NSDate*)date;
- (BOOL) isSameUTCDayAs:(NSDate*)date;
- (BOOL) isToday;
- (BOOL) isYesterday;
- (BOOL) isDayBefore;
- (BOOL) isThisYear;
- (NSString*) dayOfWeek;

+(NSDate*)startOfToday;
+(NSDate*)startOf7DaysAgo;
+(NSDate*)startOf30DaysAgo;
+(NSDate*)startOf60DaysAgo;
+(NSDate*)startOfNextWeek;
+(NSDate*)startOfThisMonth;

+(NSTimeInterval)timeIntervalFromDays:(NSInteger)days;
+(NSTimeInterval)timeIntervalFromHours:(NSInteger)hours;
+(NSTimeInterval)timeIntervalFromMinutes:(NSInteger)minutes;
+(NSTimeInterval)timeIntervalFromDays:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds;
+(NSTimeInterval)timeIntervalRoundedTo5Minutes:(NSTimeInterval)ti;

+(NSDate *)dateFromHHMMA:(NSString *)hhmma;

+(NSTimeInterval)timeIntervalFromHHMM:(NSString *)hhmm;
+(NSTimeInterval)timeIntervalFromHHMMA:(NSString *)hhmma;

+(NSString *)stringFromHHMMA:(NSDate *)hhmma;
+(NSString *)stringFromHHMM:(NSDate *)hhmm;

@end
