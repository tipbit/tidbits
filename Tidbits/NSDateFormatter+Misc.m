//
//  NSDateFormatter+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 3/29/15.
//  Copyright (c) 2015 Tipbit. All rights reserved.
//

#import "NSDateFormatter+Misc.h"


/**
 * http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 */
@implementation NSDateFormatter (Misc)


+(NSDateFormatter *)tb_dateNumeric {
    return [NSDateFormatter tb_dateFormatterFromTemplate:@"dM"];
}


+(NSDateFormatter *)tb_dateShort {
    NSDateFormatter * result = [NSDateFormatter tb_dateFormatterWithCurrentLocale];
    result.dateStyle = NSDateFormatterShortStyle;
    return result;
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


+(NSDateFormatter *)tb_hourMinutesPeriod {
    return [NSDateFormatter tb_dateFormatterFromTemplate:@"jmma"];
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


+(NSDateFormatter *)tb_timeShort {
    NSDateFormatter * result = [NSDateFormatter tb_dateFormatterWithCurrentLocale];
    result.timeStyle = NSDateFormatterShortStyle;
    return result;
}


+(NSDateFormatter *)tb_dateFormatterFromTemplate:(NSString *)template {
    NSDateFormatter * result = [NSDateFormatter tb_dateFormatterWithCurrentLocale];
    result.dateFormat = [NSDateFormatter dateFormatFromTemplate:template options:0 locale:result.locale];
    return result;
}


+(NSDateFormatter *)tb_dateFormatterWithCurrentLocale {
    NSLocale * locale = [NSLocale autoupdatingCurrentLocale];
    NSDateFormatter * result = [[NSDateFormatter alloc] init];
    result.locale = locale;
    return result;
}


@end
