//
//  TBAsserts.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/27/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import <Lumberjack/DDLog.h>

#import "Breadcrumbs.h"
#import "LoggingMacros.h"

#import "TBAsserts.h"


static void TrackAndLog(NSString * track, NSString * msg) {
    NSString * trackPrefixed = [NSString stringWithFormat:@"Assert-%@", track];
    [Breadcrumbs track:trackPrefixed];
    NSLogError(@"%@", msg);
    [DDLog flushLog];
}


#define MAKE_TRACK_AND_MSG                                                           \
    va_list args;                                                                    \
    va_start(args, desc);                                                            \
    NSString * track = [[NSString alloc] initWithFormat:breadcrumb arguments:args];  \
    NSString * msg = [[NSString alloc] initWithFormat:desc arguments:args];          \
    va_end(args)


extern void TBAssertsTrack(SEL cmd, id obj, NSString * file, NSInteger line, NSString * breadcrumb, NSString * desc, ...) {
    MAKE_TRACK_AND_MSG;
    TrackAndLog(track, msg);
}


extern void TBAssertsTrackC(NSString * func, NSString * file, NSInteger line, NSString * breadcrumb, NSString * desc, ...) {
    MAKE_TRACK_AND_MSG;
    TrackAndLog(track, msg);
}


extern void TBAssertsTrackAndRaise(SEL cmd, id obj, NSString * file, NSInteger line, NSString * breadcrumb, NSString * desc, ...) {
    MAKE_TRACK_AND_MSG;
    TrackAndLog(track, msg);
    [[NSAssertionHandler currentHandler] handleFailureInMethod:cmd object:obj file:file lineNumber:line description:@"%@", msg];
    // Unreachable, but the compiler doesn't know that because handleFailureInMethod isn't declared noreturn like it
    // should be.
    abort();
}


extern void TBAssertsTrackAndRaiseC(NSString * func, NSString * file, NSInteger line, NSString * breadcrumb, NSString * desc, ...) {
    MAKE_TRACK_AND_MSG;
    TrackAndLog(track, msg);
    [[NSAssertionHandler currentHandler] handleFailureInFunction:func file:file lineNumber:line description:@"%@", msg];
    // Unreachable, as above.
    abort();
}
