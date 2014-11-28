//
//  LoggingMacrosWrappers.h
//  Tidbits
//
//  Created by Ewan Mellor on 11/25/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

/*
 You may include this file at any point, in order to redefine all the NSLog* and DLog macros.
 In particular, you can do this to set a prefix for each log message, like this:

 #define LoggingMacrosPrefix @"SomePrefix"
 #include "LoggingMacrosWrappers.h"

 You can make the prefix stand out by wrapping it like this:

 #define LoggingMacrosPrefix LoggingMacrosTag(@"MyTag")
 #include "LoggingMacrosWrappers.h"

 This will give you a prefix like this: ⟦MyTag⟧

 */

#undef NSLog
#undef NSLogError
#undef NSLogWarn
#undef NSLogInfo
#undef NSLogUser
#undef DLog

#undef _LoggingMacrosPrefix
#ifdef LoggingMacrosPrefix
#define _LoggingMacrosPrefix LoggingMacrosPrefix @" "
#else
#define _LoggingMacrosPrefix
#endif

#define NSLogError(__fmt, ...) LOG_C_MAYBE(LOG_ASYNC_ERROR, LOG_LEVEL_ERROR, LOG_FLAG_ERROR, 0, _LoggingMacrosPrefix __fmt, ##__VA_ARGS__)
#define NSLogWarn(__fmt, ...)  LOG_C_MAYBE(LOG_ASYNC_WARN,  LOG_LEVEL_WARN,  LOG_FLAG_WARN,  0, _LoggingMacrosPrefix __fmt, ##__VA_ARGS__)
#define NSLogInfo(__fmt, ...)  LOG_C_MAYBE(LOG_ASYNC_INFO,  LOG_LEVEL_INFO,  LOG_FLAG_INFO,  0, _LoggingMacrosPrefix __fmt, ##__VA_ARGS__)
#define NSLogUser(__fmt, ...)  LOG_C_MAYBE(LOG_ASYNC_INFO,  LOG_LEVEL_USER,  LOG_FLAG_USER,  0, _LoggingMacrosPrefix __fmt, ##__VA_ARGS__)
#define NSLog(__fmt, ...)      LOG_C_MAYBE(LOG_ASYNC_INFO,  LOG_LEVEL_INFO,  LOG_FLAG_INFO,  0, _LoggingMacrosPrefix __fmt, ##__VA_ARGS__)

#if DEBUG
#define DLog(__fmt, ...) LOG_C_MAYBE(LOG_ASYNC_DEBUG, LOG_LEVEL_DEBUG, LOG_FLAG_DEBUG, 0, _LoggingMacrosPrefix __fmt, ##__VA_ARGS__)
#else
#define DLog(...)
#endif
