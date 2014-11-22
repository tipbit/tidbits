//
//  LogFormatter.m
//  Tidbits
//
//  Created by Ewan Mellor on 6/29/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#include <stdio.h>
#include <time.h>

#import <Lumberjack/Lumberjack.h>
#import "LoggingMacros.h"

#import "LogFormatter.h"


@implementation LogFormatter


+(LogFormatter*)formatterRegisteredAsDefaultASLAndTTY {
    LogFormatter * aslFormatter = [LogFormatter formatterRegisteredAsDefaultASL];
    [LogFormatter registerDefaultTTYLogger];
    return aslFormatter;
}


+(LogFormatter*)formatterRegisteredAsDefaultASL {
    LogFormatter* aslFormatter = [[LogFormatter alloc] init];
    DDASLLogger* aslLogger = [DDASLLogger sharedInstance];
    aslLogger.logFormatter = aslFormatter;
    [DDLog addLogger:aslLogger withLogLevel:255];

    return aslFormatter;
}


+(void)registerDefaultTTYLogger {
    DDTTYLogger* ttyLogger = [DDTTYLogger sharedInstance];
    ttyLogger.logFormatter = [[LogFormatterTTY alloc] init];;
    [DDLog addLogger:ttyLogger withLogLevel:255];

    [ttyLogger setColorsEnabled:YES];
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    [ttyLogger setForegroundColor:[UIColor brownColor] backgroundColor:nil forFlag:LOG_FLAG_USER];
    [ttyLogger setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:LOG_FLAG_ERROR];
    [ttyLogger setForegroundColor:[UIColor purpleColor] backgroundColor:nil forFlag:LOG_FLAG_WARN];
    [ttyLogger setForegroundColor:[UIColor darkGrayColor] backgroundColor:nil forFlag:LOG_FLAG_DEBUG];
    [ttyLogger setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];
#endif
}


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

        case LOG_LEVEL_USER:
            return "[user]";

        case LOG_LEVEL_INFO:
            return "info ";

        case LOG_LEVEL_VERBOSE:
            return "debug";

        default:
            return "?????";
    }
}


@end

@interface LogFormatterTTY ()
{
	NSDateFormatter *dateFormatter;
}
@end

@implementation LogFormatterTTY
- (id)init
{
	if ((self = [super init]))
	{
			dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4]; // 10.4+ style
			[dateFormatter setDateFormat:@"hh:mm:ss.SSS"];
	}
	return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
	NSString *dateAndTime = [dateFormatter stringFromDate:(logMessage->timestamp)];
    NSString *flag;
    if (logMessage->logFlag & LOG_FLAG_FATAL) {
        flag = @"F";
    }
    else if(logMessage->logFlag & LOG_FLAG_ERROR) {
        flag = @"E";
    }
    else if(logMessage->logFlag & LOG_FLAG_WARN) {
        flag = @"W";
    }
    else if(logMessage->logFlag & LOG_FLAG_USER) {
        flag = @"U";
    }
    else if(logMessage->logFlag & LOG_FLAG_INFO) {
        flag = @"I";
    }
    else if(logMessage->logFlag & LOG_FLAG_DEBUG) {
        flag = @"D";
    }
    else if(logMessage->logFlag & LOG_FLAG_VERBOSE) {
        flag = @"V";
    }

	NSString *msg = [NSString stringWithFormat:@"%@ %@ %-4x %-4d %s %@",
                     flag,
                     dateAndTime,
                     logMessage->machThreadID,
                     logMessage->lineNumber,
                     logMessage->function,
                     logMessage->logMsg];
    return msg;
}

@end
