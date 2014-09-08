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


static void LogAndFlush(NSString * msg) {
    NSLogError(@"%@", msg);
    [DDLog flushLog];
}


static void TrackAndLog(NSString * track, NSString * msg) {
    NSString * trackPrefixed = [NSString stringWithFormat:@"Assert-%@", track];
    [Breadcrumbs track:trackPrefixed];
    LogAndFlush(msg);
}


#define MAKE_MSG                                                                     \
    va_list args;                                                                    \
    va_start(args, desc);                                                            \
    NSString * msg = [[NSString alloc] initWithFormat:desc arguments:args];          \
    va_end(args)


#define MAKE_TRACK_AND_MSG                                                           \
    va_list args;                                                                    \
    va_start(args, desc);                                                            \
    NSString * track = [[NSString alloc] initWithFormat:breadcrumb arguments:args];  \
    va_end(args);                                                                    \
    va_start(args, desc);                                                            \
    NSString * msg = [[NSString alloc] initWithFormat:desc arguments:args];          \
    va_end(args)


// We need the abort because that line is unreachable, but the compiler doesn't know
// that because handleFailureInMethod isn't declared noreturn like it should be.
#define RAISE                                                                        \
    [[NSAssertionHandler currentHandler] handleFailureInMethod:cmd object:obj        \
                                         file:file lineNumber:line                   \
                                         description:@"%@", msg];                    \
    abort()

#define RAISEC                                                                       \
    [[NSAssertionHandler currentHandler] handleFailureInFunction:func                \
                                         file:file lineNumber:line                   \
                                         description:@"%@", msg];                    \
    abort();


extern void TBAssertsRaise(SEL cmd, id obj, NSString * file, NSInteger line, NSString * desc, ...) {
    MAKE_MSG;
    LogAndFlush(msg);
    RAISE;
}


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
    RAISE;
}


extern void TBAssertsTrackAndRaiseC(NSString * func, NSString * file, NSInteger line, NSString * breadcrumb, NSString * desc, ...) {
    MAKE_TRACK_AND_MSG;
    TrackAndLog(track, msg);
    RAISEC;
}
