//
//  FeatureMacros.h
//  Tidbits
//
//  Created by Ewan Mellor on 9/28/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#ifndef Tidbits_FeatureMacros_h
#define Tidbits_FeatureMacros_h

#include <Foundation/NSObjCRuntime.h>


#define IS_IPAD (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define IS_IPHONE4 ((UIScreen.mainScreen.bounds.size.height == 480) || (UIScreen.mainScreen.bounds.size.width == 480))
#define IS_IPHONE5 ((UIScreen.mainScreen.bounds.size.height == 568) || (UIScreen.mainScreen.bounds.size.width == 568))
#define IS_IPHONE6 ((UIScreen.mainScreen.bounds.size.height == 667) || (UIScreen.mainScreen.bounds.size.width == 667))
#define IS_IPHONE6PLUS ((UIScreen.mainScreen.bounds.size.height == 414) || (UIScreen.mainScreen.bounds.size.width == 414))
#define IS_IOS8_OR_GREATER (floor(NSFoundationVersionNumber) >  NSFoundationVersionNumber_iOS_7_1)
#define IS_IOS9_OR_GREATER (floor(NSFoundationVersionNumber) >  NSFoundationVersionNumber_iOS_8_3)

#define IS_PORTRAIT (UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation))
#define IS_LANDSCAPE (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation))

#endif
