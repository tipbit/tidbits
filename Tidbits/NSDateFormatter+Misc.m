//
//  NSDateFormatter+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 3/29/15.
//  Copyright (c) 2015 Tipbit. All rights reserved.
//

#import "CurrentLocaleInfo.h"

#import "NSDateFormatter+Misc.h"


/**
 * http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 */
@implementation NSDateFormatter (Misc)


+(NSDateFormatter *)tb_dateShort {
    return [NSDateFormatter tb_dateFormatterWithCurrentLocaleDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}


+(NSDateFormatter *)tb_dateMedium {
    return [NSDateFormatter tb_dateFormatterWithCurrentLocaleDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
}


+(NSDateFormatter *)tb_dateTimeLong {
    return [NSDateFormatter tb_dateFormatterWithCurrentLocaleDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle];
}


+(NSDateFormatter *)tb_timeShort {
    return [NSDateFormatter tb_dateFormatterWithCurrentLocaleDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}


+(NSDateFormatter *)tb_dateNumeric {
    return [NSDateFormatter tb_dateFormatterFromTemplate:@"dM"];
}


+(NSDateFormatter *)tb_dateYearNumeric {
    return [NSDateFormatter tb_dateFormatterFromTemplate:@"dMyyyy"];
}


+(NSDateFormatter *)tb_dateYearNumericHourMinutes {
    return [NSDateFormatter tb_dateFormatterFromTemplate:@"dMyyyyjmm"];
}


+(NSDateFormatter *)tb_dateYearNumericHourMinutesOptionalPeriod {
    return (CurrentLocaleInfo.instance.uses24HourClock ? [NSDateFormatter tb_dateYearNumericHourMinutes] : [NSDateFormatter tb_dateYearNumericHourMinutesPeriod]);
}


+(NSDateFormatter *)tb_dateYearNumericHourMinutesPeriod {
    return [NSDateFormatter tb_dateFormatterFromTemplate:@"dMyyyyjmma"];
}


+(NSDateFormatter *)tb_dayDateFull {
    return [NSDateFormatter tb_dateFormatterFromTemplate:@"dEEEEMMMM"];
}


+(NSDateFormatter *)tb_dayDateYearFull {
    return [NSDateFormatter tb_dateFormatterFromTemplate:@"dEEEEMMMMyyyy"];
}


+(NSDateFormatter *)tb_dayOfWeekFull {
    return [NSDateFormatter tb_dateFormatterFromTemplate:@"EEEE"];
}


+(NSDateFormatter *)tb_dayOfMonth {
    return [NSDateFormatter tb_dateFormatterFromTemplate:@"d"];
}


+(NSDateFormatter *)tb_hourMinutes {
    return [NSDateFormatter tb_dateFormatterFromTemplate:@"jmm"];
}


+(NSDateFormatter *)tb_hourMinutesOptionalPeriod {
    return (CurrentLocaleInfo.instance.uses24HourClock ? [NSDateFormatter tb_hourMinutes] : [NSDateFormatter tb_hourMinutesPeriod]);
}


+(NSDateFormatter *)tb_hourMinutesPeriod {
    return [NSDateFormatter tb_dateFormatterFromTemplate:@"jmma"];
}


+(NSDateFormatter *)tb_hour {
    return [NSDateFormatter tb_dateFormatterFromTemplate:@"j"];
}


+(NSDateFormatter *)tb_hourOptionalPeriod {
    return (CurrentLocaleInfo.instance.uses24HourClock ? [NSDateFormatter tb_hour] : [NSDateFormatter tb_hourPeriod]);
}


+(NSDateFormatter *)tb_hourPeriod {
    return [NSDateFormatter tb_dateFormatterFromTemplate:@"ja"];
}


+(NSDateFormatter *)tb_monthFull {
    return [NSDateFormatter tb_dateFormatterFromTemplate:@"MMMM"];
}


+(NSDateFormatter *)tb_monthYearFull {
    return [NSDateFormatter tb_dateFormatterFromTemplate:@"MMMMyyyy"];
}


+(NSDateFormatter *)tb_dateFormatterFromTemplate:(NSString *)template {
    NSDateFormatter * result = [NSDateFormatter tb_dateFormatterWithCurrentLocale];
    result.dateFormat = [NSDateFormatter dateFormatFromTemplate:template options:0 locale:result.locale];
    return result;
}


+(NSDateFormatter *)tb_dateFormatterWithCurrentLocaleDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter * result = [NSDateFormatter tb_dateFormatterWithCurrentLocale];
    result.dateStyle = dateStyle;
    result.timeStyle = timeStyle;
    return result;
}


+(NSDateFormatter *)tb_dateFormatterWithCurrentLocale {
    NSLocale * locale = [NSLocale autoupdatingCurrentLocale];
    NSDateFormatter * result = [[NSDateFormatter alloc] init];
    result.locale = locale;
    return result;
}


@end
