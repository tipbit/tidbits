//
//  FeatureMacros.h
//  Tidbits
//
//  Created by Ewan Mellor on 9/28/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#ifndef Tidbits_FeatureMacros_h
#define Tidbits_FeatureMacros_h

#ifndef NSFoundationVersionNumber_iOS_7_1
#define NSFoundationVersionNumber_iOS_7_1 1047.25
#endif


#define IS_IPAD (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define IS_IPHONE4 ((UIScreen.mainScreen.bounds.size.height == 480) || (UIScreen.mainScreen.bounds.size.width == 480))
#define IS_IPHONE5 ((UIScreen.mainScreen.bounds.size.height == 568) || (UIScreen.mainScreen.bounds.size.width == 568))
#define IS_IPHONE6 ((UIScreen.mainScreen.bounds.size.height == 667) || (UIScreen.mainScreen.bounds.size.width == 667))
#define IS_IPHONE6PLUS ((UIScreen.mainScreen.bounds.size.height == 414) || (UIScreen.mainScreen.bounds.size.width == 414))
#define IS_IOS8_OR_GREATER (floor(NSFoundationVersionNumber) >  NSFoundationVersionNumber_iOS_7_1)


#endif
