//
//  LogCollector.m
//  Tidbits
//
//  Created by Ewan Mellor on 3/19/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "LogCollector.h"


@interface LogCollector ()

/**
 * NSString array.  Each of the log messages that we're collecting.
 */
@property (nonatomic) NSMutableArray * buffer;

@property (nonatomic) id<DDLogFormatter> myFormatter;

@end


@implementation LogCollector


-(instancetype)init {
    self = [super init];
    if (self) {
        _buffer = [NSMutableArray array];
    }
    return self;
}


-(void)logMessage:(DDLogMessage *)logMessage {
    NSString * msg = [self.myFormatter formatLogMessage:logMessage] ?: logMessage->logMsg;
    [self.buffer addObject:msg];
}


-(id<DDLogFormatter>)logFormatter {
    return self.myFormatter;
}


-(void)setLogFormatter:(id<DDLogFormatter>)formatter {
    self.myFormatter = formatter;
}


-(NSArray *)collect {
    [DDLog flushLog];
    NSArray * result = self.buffer;
    self.buffer = [NSMutableArray array];
    return result;
}


@end
