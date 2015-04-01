//
//  CurrentLocaleInfo.h
//  Tidbits
//
//  Created by Ewan Mellor on 4/1/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CurrentLocaleInfo : NSObject

+(CurrentLocaleInfo *)instance;

@property (nonatomic, readonly) BOOL uses24HourClock;

@end
