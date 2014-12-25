//
//  LogFormatter.h
//  Tidbits
//
//  Created by Ewan Mellor on 6/29/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Lumberjack/DDLog.h>

@interface LogFormatter : NSObject <DDLogFormatter>

+(LogFormatter*)formatterRegisteredAsDefaultASLAndTTY;
+(LogFormatter*)formatterRegisteredAsDefaultASLAndTTYUsingTTYFormatter:(BOOL)useTtyFormatter;
+(LogFormatter*)formatterRegisteredAsDefaultASL;

#if DEBUG || RELEASE_TESTING

-(NSString *)formatLogMessageB:(DDLogMessage *)logMessage;

#endif

@end


@interface LogFormatterTTY : NSObject <DDLogFormatter>

#if DEBUG || RELEASE_TESTING

-(NSString *)formatLogMessageB:(DDLogMessage *)logMessage;

#endif

@end
