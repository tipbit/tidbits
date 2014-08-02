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
+(LogFormatter*)formatterRegisteredAsDefaultASL;
+(void)registerDefaultTTYLogger;

@end

@interface LogFormatterTTY : NSObject <DDLogFormatter>

@end
