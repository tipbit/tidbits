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


// Set this to force the use of LogFormatter rather than
// LogFormatterTTY for the TTY logger (i.e. the one that
// shows in the Xcode console).
// This means that you get full date stamps in particular.
#define FORCE_LOGFORMATTER_ON_TTY 0

// Set this to include the thread ID in the TTY logger.
// This is 6-7% slower and is only of value if you've got
// a nasty threading problem so it's off by default.
#define INCLUDE_THREAD_ID_ON_TTY 0


@implementation LogFormatter


+(LogFormatter*)formatterRegisteredAsDefaultASLAndTTY {
    return [LogFormatter formatterRegisteredAsDefaultASLAndTTYUsingTTYFormatter:YES];
}


+(LogFormatter *)formatterRegisteredAsDefaultASLAndTTYUsingTTYFormatter:(BOOL)useTtyFormatter {
    LogFormatter * aslFormatter = [LogFormatter formatterRegisteredAsDefaultASL];
#if FORCE_LOGFORMATTER_ON_TTY
    useTtyFormatter = NO;
#endif
    NSObject<DDLogFormatter> * ttyFormatter = useTtyFormatter ? [[LogFormatterTTY alloc] init] : [[LogFormatter alloc] init];
    [LogFormatter registerDefaultTTYLogger:ttyFormatter];
    return aslFormatter;
}


+(LogFormatter*)formatterRegisteredAsDefaultASL {
    LogFormatter* aslFormatter = [[LogFormatter alloc] init];
    DDASLLogger* aslLogger = [DDASLLogger sharedInstance];
    aslLogger.logFormatter = aslFormatter;
    [DDLog addLogger:aslLogger withLogLevel:255];

    return aslFormatter;
}


+(void)registerDefaultTTYLogger:(NSObject<DDLogFormatter> *)formatter {
    DDTTYLogger* ttyLogger = [DDTTYLogger sharedInstance];
    ttyLogger.logFormatter = formatter;
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
    char time_level_str[30];
    struct tm tm;
    NSTimeInterval ts = [logMessage->timestamp timeIntervalSince1970];
    time_t ts_whole = (time_t)ts;
    int ts_frac = (int)round(((ts - (double)ts_whole) * 1000.0));
    gmtime_r(&ts_whole, &tm);
    // Using snprintf for the fixed-length fields is 26-29% faster than putting it all in the stringWithFormat call.
    snprintf(time_level_str, 30, "%4d-%02d-%02d %02d:%02d:%02d.%03d %5s", tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec, ts_frac, logLevelToStr(logMessage->logLevel));
    return [NSString stringWithFormat:@"%s %s:%i | %@", time_level_str, logMessage->function, logMessage->lineNumber, logMessage->logMsg];
}


static const char * logLevelToStr(int level) {
    switch (level) {
        case LOG_LEVEL_FATAL:
            return "fatal";

        case LOG_LEVEL_ERROR:
            return "error";

        case LOG_LEVEL_WARN:
            return "warn ";

        case LOG_LEVEL_USER:
            return "user ";

        case LOG_LEVEL_INFO:
            return "info ";

        case LOG_LEVEL_DEBUG:
            return "debug";

        default:
            return "?????";
    }
}


-(NSString *)formatLogMessageB:(DDLogMessage *)logMessage {
    char time_level_str[30];
    struct tm tm;
    NSTimeInterval ts = [logMessage->timestamp timeIntervalSince1970];
    time_t ts_whole = (time_t)ts;
    int ts_frac = (int)round((ts - (double)ts_whole) * 1000.0);
    gmtime_r(&ts_whole, &tm);
    snprintf(time_level_str, sizeof(time_level_str), "%4d-%02d-%02d %02d:%02d:%02d.%03d %5s", tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec, ts_frac, logLevelToStr(logMessage->logLevel));
    return [NSString stringWithFormat:@"%s %s:%i | %@", time_level_str, logMessage->function, logMessage->lineNumber, logMessage->logMsg];
}


@end


@implementation LogFormatterTTY


-(NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    char time_level_str[15];
    struct tm tm;
    NSTimeInterval ts = [logMessage->timestamp timeIntervalSince1970];
    time_t ts_whole = (time_t)ts;
    int ts_frac = (int)round((ts - (double)ts_whole) * 1000.0);
    localtime_r(&ts_whole, &tm);
    // Using snprintf for the fixed-length fields is 26-29% faster than putting it all in the stringWithFormat call.
    snprintf(time_level_str, sizeof(time_level_str), "%c %02d:%02d:%02d.%03d", logLevelToChar(logMessage->logLevel), tm.tm_hour, tm.tm_min, tm.tm_sec, ts_frac);
    return [NSString stringWithFormat:@"%s"
#if INCLUDE_THREAD_ID_ON_TTY
            " %-4x"
#endif
            " %s:%d | %@",
            time_level_str,
#if INCLUDE_THREAD_ID_ON_TTY
            logMessage->machThreadID,
#endif
            logMessage->function,
            logMessage->lineNumber,
            logMessage->logMsg];
}


static char logLevelToChar(int level) {
    switch (level) {
        case LOG_LEVEL_FATAL:
            return 'F';

        case LOG_LEVEL_ERROR:
            return 'E';

        case LOG_LEVEL_WARN:
            return 'W';

        case LOG_LEVEL_USER:
            return 'U';

        case LOG_LEVEL_INFO:
            return 'I';

        case LOG_LEVEL_DEBUG:
            return 'D';

        default:
            return '?';
    }
}


#if DEBUG || RELEASE_TESTING

-(NSString *)formatLogMessageB:(DDLogMessage *)logMessage {
    char time_level_str[15];
    struct tm tm;
    NSTimeInterval ts = [logMessage->timestamp timeIntervalSince1970];
    time_t ts_whole = (time_t)ts;
    int ts_frac = (int)round((ts - (double)ts_whole) * 1000.0);
    localtime_r(&ts_whole, &tm);
    // Using snprintf for the fixed-length fields is 26-29% faster than putting it all in the stringWithFormat call.
    snprintf(time_level_str, sizeof(time_level_str), "%c %02d:%02d:%02d.%03d", logLevelToChar(logMessage->logLevel), tm.tm_hour, tm.tm_min, tm.tm_sec, ts_frac);
    return [NSString stringWithFormat:@"%s %-4x %s:%d | %@",
            time_level_str,
            logMessage->machThreadID,
            logMessage->function,
            logMessage->lineNumber,
            logMessage->logMsg];
}

#endif


@end
