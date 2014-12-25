//
//  TBTestHelpers.h
//  Tidbits
//
//  Created by Ewan Mellor on 12/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StandardBlocks.h"
#import "WaitFor.h"


extern bool isReachable(NSString* hostname);

/**
 * Run blockA and blockB until we have at least 10 seconds of wallclock execution time and 10 repetitions.
 *
 * @param outDelta Set to the difference in wallclock execution time between the two blocks.  If positive, blockB is faster.
 * @param outTotal Set to the total wallclock execution time.
 */
extern void comparePerformance(VoidBlock blockA, VoidBlock blockB, NSTimeInterval * outDelta, NSTimeInterval * outTotal);

/**
 * Run comparePerformance and log the results.  The quoted percentage is 100 * (slower - faster) / (slower + faster) across
 * the total execution.
 */
extern void comparePerformanceAndLogResult(VoidBlock blockA, VoidBlock blockB);
