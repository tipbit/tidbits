//
//  TBAsserts.h
//  Tidbits
//
//  Created by Ewan Mellor on 6/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#ifndef TBClientLib_TBAsserts_h
#define TBClientLib_TBAsserts_h



#ifdef DEBUG
#define TBAssert(condition, desc, ...) do { NSAssert(condition, desc, ## __VA_ARGS__); } while(false)
#else
#define TBAssert(condition, ...) do { if (!(condition)) { NSLog(__VA_ARGS__); } } while(false)
#endif


#define TBCAssertAllBuilds(__cond, __breadcrumb, __desc, ...)                                        \
    do {                                                                                             \
        if (!(__cond)) {                                                                             \
            [Breadcrumbs track:[NSString stringWithFormat:(__breadcrumb), ## __VA_ARGS__]];          \
            NSLogError((__desc), ## __VA_ARGS__);                                                    \
            [DDLog flushLog];                                                                        \
            [[NSAssertionHandler currentHandler] handleFailureInFunction:@(__PRETTY_FUNCTION__)      \
                                                                    file:@(__FILE__)                 \
                                                              lineNumber:__LINE__                    \
                                                             description:(__desc), ## __VA_ARGS__];  \
        }                                                                                            \
    } while (false)


#define AssertOnBackgroundThread() NSAssert(!NSThread.isMainThread, @"Must be on background thread.  GCOV_EXCL_LINE")
#define AssertOnBackgroundThreadC() assert(!NSThread.isMainThread)

// To avoid the cost of this assert on the UI thread, we turn it off in release builds.
// It's not very expensive, but there are a lot of them, and they're on hot paths.
// For the background thread, there's no concern about the cost.
#ifdef DEBUG
#define AssertOnMainThread() NSAssert(NSThread.isMainThread, @"Must be on main thread.  GCOV_EXCL_LINE")
#else
#define AssertOnMainThread()
#endif


#endif
