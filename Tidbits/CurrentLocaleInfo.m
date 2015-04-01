//
//  CurrentLocaleInfo.m
//  Tidbits
//
//  Created by Ewan Mellor on 4/1/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "NSDate+Ext.h"
#import "NSDateFormatter+Misc.h"

#import "CurrentLocaleInfo.h"


static CurrentLocaleInfo * instance_ = nil;


@interface CurrentLocaleInfo ()

@property (nonatomic) BOOL uses24HourClock;

@end


@implementation CurrentLocaleInfo


+(void)initialize {
    instance_ = [[CurrentLocaleInfo alloc] init];
}


+(CurrentLocaleInfo *)instance {
    return instance_;
}


-(instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
        [self localeDidChange];
    }
    return self;
}


-(void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    assert(false);
}


-(void)localeDidChange {
    self.uses24HourClock = calcUses24HourClock();
}


static BOOL calcUses24HourClock() {
    NSDateFormatter * formatter = [NSDateFormatter tb_timeShort];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDate * date = [NSDate dateWithTimeIntervalSinceReferenceDate:(23 * 60 * 60)];
    NSString * str = [formatter stringFromDate:date];
    return [str containsString:@"23"];
}


@end
