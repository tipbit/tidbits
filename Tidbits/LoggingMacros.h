//
//  LoggingMacros.h
//  TBClientLib
//
//  Created by Ewan Mellor on 5/10/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#ifndef Tidbits_LoggingMacros_h
#define Tidbits_LoggingMacros_h

#include <Lumberjack/DDLog.h>

#define NSLogError(__fmt, ...) LOG_OBJC_MAYBE(LOG_ASYNC_ERROR, LOG_LEVEL_INFO, LOG_FLAG_ERROR, 0, __fmt, ##__VA_ARGS__)
#define NSLogWarn(__fmt, ...) LOG_OBJC_MAYBE(LOG_ASYNC_WARN, LOG_LEVEL_INFO, LOG_FLAG_WARN, 0, __fmt, ##__VA_ARGS__)
#define NSLogInfo(__fmt, ...) LOG_OBJC_MAYBE(LOG_ASYNC_INFO, LOG_LEVEL_INFO, LOG_FLAG_INFO, 0, __fmt, ##__VA_ARGS__)

#define NSLog(__fmt, ...) LOG_C_MAYBE(LOG_ASYNC_INFO,    LOG_LEVEL_INFO, LOG_FLAG_INFO,    0, __fmt, ##__VA_ARGS__)

#if DEBUG
#define DLog(__fmt, ...) LOG_C_MAYBE(LOG_ASYNC_VERBOSE, LOG_LEVEL_VERBOSE, LOG_FLAG_VERBOSE, 0, __fmt, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ELog(__err) {if (__err) NSLogError(@"%@", __err)}

#endif
