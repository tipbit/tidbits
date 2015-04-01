//
//  NSDateFormatter+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 3/29/15.
//  Copyright (c) 2015 Tipbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Misc)

/*
 * These are using NSDateFormatter.dateStyle and .timeStyle.
 * This gives locale-dependent formats, and makes locale-dependent
 * decisions on day/month/year order, 12- vs 24-hour clock, use of AM/PM, etc.
 */

+(NSDateFormatter *)tb_dateShort;
+(NSDateFormatter *)tb_dateTimeLong;
+(NSDateFormatter *)tb_timeShort;

/*
 * These are using NSDateFormatter.dateFormat and .timeFormat with dateFormatFromTemplate.
 *
 * This gives locale-dependent formats, and makes locale-dependent
 * decisions on day/month/year order and 12- vs 24-hour clock (since they use 'j' in the template').
 * The presence or absence of an AM/PM indicator (the "period" in Unicode's terminology) or
 * the year or day of the week is specific to the method call.
 *
 * This gives more control than the calls above, but you need to be careful to consider the
 * use of AM/PM in locales that wouldn't normally use it.
 *
 * http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 */

+(NSDateFormatter *)tb_dateNumeric;
+(NSDateFormatter *)tb_dateYearNumeric;
+(NSDateFormatter *)tb_dateYearNumericHourMinutes;
+(NSDateFormatter *)tb_dateYearNumericHourMinutesPeriod;
+(NSDateFormatter *)tb_dayDateFull;
+(NSDateFormatter *)tb_dayDateYearFull;
+(NSDateFormatter *)tb_dayOfWeekFull;
+(NSDateFormatter *)tb_dayOfMonth;
+(NSDateFormatter *)tb_hourMinutes;
+(NSDateFormatter *)tb_hourMinutesPeriod;
+(NSDateFormatter *)tb_hourPeriod;
+(NSDateFormatter *)tb_monthFull;
+(NSDateFormatter *)tb_monthYearFull;

@end
