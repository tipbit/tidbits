//
//  LogCollector.h
//  Tidbits
//
//  Created by Ewan Mellor on 3/19/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Lumberjack/Lumberjack.h>


/**
 * This class acts as a DDLogger, so it receives log messages via Lumberjack.
 * It holds them in a buffer until you retrieve them with collect.
 *
 * This is used so that we can collect the logs specific to a test run.
 */
@interface LogCollector : NSObject <DDLogger>

-(NSArray *)collect;

@end
