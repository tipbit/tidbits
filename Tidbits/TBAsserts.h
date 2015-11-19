//
//  TBAsserts.h
//  Tidbits
//
//  Created by Ewan Mellor on 6/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//


/*
  This header defines the following macros:

    TBAssert
    TBCAssert
    TBAssertDebugBuilds
    TBCAssertDebugBuilds
    TBParameterAssert
    TBCParameterAssert

  These should be compared to the NS* equivalents, since they all have similar semantics
  and raise the same exception at the end.

  Before they raise an exception though, they will use Breadcrumbs to add a tracking code,
  NSLogError to log a message, and [DDLog flushLog] to flush the log to disk.  All this is
  intended to get as much information into the log file and crash dump before we crash.

  It also has

    AssertOnBackgroundThread
    AssertOnBackgroundThreadC
    AssertOnMainThread

  The two BackgroundThread asserts are live in all builds.  AssertOnMainThread is only live in
  debug builds, to preserve main thread performance.

 */

#ifndef Tidbits_TBAsserts_h
#define Tidbits_TBAsserts_h

NS_ASSUME_NONNULL_BEGIN


#define TBAssertBody(__func, __cond, __breadcrumb, __desc, ...)                                            \
    (__builtin_expect(!(__cond), 0) ?                                                                      \
        __func(_cmd, self, @(__FILE__), __LINE__, (__breadcrumb), (__desc), ## __VA_ARGS__) :              \
        (void)0)


#define TBCAssertBody(__func, __cond, __breadcrumb, __desc, ...)                                           \
    (__builtin_expect(!(__cond), 0) ?                                                                      \
        __func(@(__PRETTY_FUNCTION__), @(__FILE__), __LINE__, (__breadcrumb), (__desc), ## __VA_ARGS__) :  \
        (void)0)


#define TBAssert(__cond, __breadcrumb, __desc, ...)                                                        \
    TBAssertBody(TBAssertsTrackAndRaise, __cond, __breadcrumb, __desc, ## __VA_ARGS__)

#define TBCAssert(__cond, __breadcrumb, __desc, ...)                                                       \
    TBCAssertBody(TBAssertsTrackAndRaiseC, __cond, __breadcrumb, __desc, ## __VA_ARGS__)


#if DEBUG

#define TBAssertDebugBuilds(__cond, __breadcrumb, __desc, ...)                                             \
    TBAssertBody(TBAssertsTrackAndRaise, __cond, __breadcrumb, __desc, ## __VA_ARGS__)

#define TBCAssertDebugBuilds(__cond, __breadcrumb, __desc, ...)                                            \
    TBCAssertBody(TBAssertsTrackAndRaiseC, __cond, __breadcrumb, __desc, ## __VA_ARGS__)

#else

#define TBAssertDebugBuilds(__cond, __breadcrumb, __desc, ...)                                             \
    TBAssertBody(TBAssertsTrack, __cond, __breadcrumb, __desc, ## __VA_ARGS__)

#define TBCAssertDebugBuilds(__cond, __breadcrumb, __desc, ...)                                            \
    TBCAssertBody(TBAssertsTrackC, __cond, __breadcrumb, __desc, ## __VA_ARGS__)

#endif


#define TBParameterAssert(__cond) \
    TBAssert(__cond, @"Param", @"Invalid parameter not satisfying " @#__cond)
#define TBCParameterAssert(__cond) \
    TBCAssert(__cond, @"Param", @"Invalid parameter not satisfying " @#__cond)
#define TBParameterAssertDebugBuilds(__cond) \
    TBAssertDebugBuilds(__cond, @"Param", @"Invalid parameter not satisfying " @#__cond)
#define TBCParameterAssertDebugBuilds(__cond) \
    TBCAssertDebugBuilds(__cond, @"Param", @"Invalid parameter not satisfying " @#__cond)


#define TBAssertRaise(__desc, ...)                                                                         \
    TBAssertsRaise(_cmd, self, @(__FILE__), __LINE__, (__desc), ## __VA_ARGS__)


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


@interface _TBAssertNotNilBox<__covariant Type>

-(nonnull Type)toNonnull;

@end


#define TBAssertNotNil(__x)                                            \
    ({                                                                 \
        TBAssert(__x != nil, @"BadNil", @"Invalid nil value " @#__x);  \
        _TBAssertNotNilBox<typeof(__x)> * __box;                       \
        (typeof(__box.toNonnull))__x;                                  \
    })


#define TBCAssertNotNil(__x)                                           \
    ({                                                                 \
        TBCAssert(__x != nil, @"BadNil", @"Invalid nil value " @#__x); \
        _TBAssertNotNilBox<typeof(__x)> * __box;                       \
        (typeof(__box.toNonnull))__x;                                  \
    })


extern void TBAssertsRaise(SEL cmd, id obj, NSString * file, NSInteger line, NSString * desc, ...) NS_FORMAT_FUNCTION(5, 6) __attribute__((noreturn));
extern void TBAssertsTrack(SEL cmd, id obj, NSString * file, NSInteger line, NSString * breadcrumb, NSString * desc, ...) NS_FORMAT_FUNCTION(6, 7);
extern void TBAssertsTrackC(NSString * func, NSString * file, NSInteger line, NSString * breadcrumb, NSString * desc, ...) NS_FORMAT_FUNCTION(5, 6);
extern void TBAssertsTrackAndRaise(SEL cmd, id obj, NSString * file, NSInteger line, NSString * breadcrumb, NSString * desc, ...) NS_FORMAT_FUNCTION(6, 7) __attribute__((noreturn));
extern void TBAssertsTrackAndRaiseC(NSString * func, NSString * file, NSInteger line, NSString * breadcrumb, NSString * desc, ...) NS_FORMAT_FUNCTION(5, 6) __attribute__((noreturn));


NS_ASSUME_NONNULL_END

#endif
