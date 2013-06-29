//
//  LogFormatter.m
//  Tidbits
//
//  Created by Ewan Mellor on 6/29/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#include <stdio.h>
#include <time.h>

#import "LogFormatter.h"


@implementation LogFormatter

-(NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    char time_str[24];
    struct tm tm;
    NSTimeInterval ts = [logMessage->timestamp timeIntervalSince1970];
    time_t ts_whole = (time_t)ts;
    int ts_frac = (int)((ts - (double)ts_whole) * 1000.0);
    gmtime_r(&ts_whole, &tm);
    snprintf(time_str, 24, "%4d-%02d-%02d %02d:%02d:%02d.%03d", tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec, ts_frac);
	return [NSString stringWithFormat:@"%s %s %s:%i | %@", time_str, logLevelToStr(logMessage->logLevel), logMessage->function, logMessage->lineNumber, logMessage->logMsg];
}


static char* logLevelToStr(int level) {
    switch (level) {
        case LOG_LEVEL_ERROR:
            return "error";

        case LOG_LEVEL_WARN:
            return "warn ";

        case LOG_LEVEL_INFO:
            return "info ";

        case LOG_LEVEL_VERBOSE:
            return "debug";

        default:
            return "?????";
    }
}


@end
