//
//  TBAsserts.h
//  TBClientLib
//
//  Created by Ewan Mellor on 6/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#ifndef TBClientLib_TBAsserts_h
#define TBClientLib_TBAsserts_h


#define AssertOnBackgroundThread() NSAssert(!NSThread.isMainThread, @"Must be on background thread")

// To avoid the cost of this assert on the UI thread, we turn it off in release builds.
// It's not very expensive, but there are a lot of them, and they're on hot paths.
// For the background thread, there's no concern about the cost.
#ifdef DEBUG
#define AssertOnMainThread() NSAssert(NSThread.isMainThread, @"Must be on main thread")
#else
#define AssertOnMainThread()
#endif


#endif
