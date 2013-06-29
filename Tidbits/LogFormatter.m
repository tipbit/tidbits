//
//  LogFormatter.m
//  Tidbits
//
//  Created by Ewan Mellor on 6/29/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "LogFormatter.h"

@implementation LogFormatter

-(NSString *)formatLogMessage:(DDLogMessage *)logMessage {
	return [NSString stringWithFormat:@"%@ | %s @ %i | %@", logMessage.fileName, logMessage->function, logMessage->lineNumber, logMessage->logMsg];
}

@end
