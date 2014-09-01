//
//  IdleState.m
//  TBClientLib
//
//  Created by Ewan Mellor on 5/9/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#include <ifaddrs.h>
#include <net/if.h>

#import "Dispatch.h"
#import "LoggingMacros.h"

#import "IdleState.h"


#define kMaxIdleTimeSeconds 5.0
#define kNetworkTimerSeconds 2.0
#define kNetworkLoaded 10000


volatile bool idleStateUserIdle = true;
volatile bool idleStateNetworkIdle = true;

NSString * const IdleStateChangedNotification = @"IdleStateChangedNotification";


@interface IdleState ()

@property (nonatomic) u_int32_t lastNetCount;
@property (nonatomic) NSTimer * idleTimer;
@property (nonatomic) NSTimer * netTimer;

@end


@implementation IdleState


static IdleState * _instance;


+(void)initialize {
    _instance = [[IdleState alloc] init];
}


+(void)startNetTimer {
    [_instance startNetTimer];
}


+(void)userIsActive {
    [_instance userIsActive];
}


-(id)init {
    self = [super init];
    if (self) {
        _lastNetCount = 0;
        _idleTimer = nil;
        _netTimer = nil;
    }
    return self;
}


-(void)startNetTimer {
    DLog(@"Starting network timer");

    [self.netTimer invalidate];
    self.netTimer = [NSTimer scheduledTimerWithTimeInterval:kNetworkTimerSeconds
                                                     target:self
                                                   selector:@selector(netTick)
                                                   userInfo:nil
                                                    repeats:YES];
}


-(void)userIsActive {
    if (self.idleTimer) {
        if (fabs([self.idleTimer.fireDate timeIntervalSinceNow]) < kMaxIdleTimeSeconds - 1.0) {
            [self.idleTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kMaxIdleTimeSeconds]];
        }
    }
    else {
        self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:kMaxIdleTimeSeconds
                                                          target:self
                                                        selector:@selector(idleTimerFired)
                                                        userInfo:nil
                                                         repeats:NO];
    }

    if (idleStateUserIdle) {
        idleStateUserIdle = false;
        dispatchChangeNotification();
    }
}


- (void)idleTimerFired {
    DLog(@"User idle");
    if (!idleStateUserIdle) {
        idleStateUserIdle = true;
        dispatchChangeNotification();
    }
    self.idleTimer = nil;
}


-(void)netTick {
    u_int32_t newNetCount = getTotalSentAndReceived();
    u_int32_t since = newNetCount - self.lastNetCount;
#if 0
    if (since > 10000) {
        DLog(@"Network bytes sent/received last %f seconds: %d", kNetworkTimerSeconds, since);
    }
#endif

    bool newNetIdle = (since < kNetworkLoaded);
    if (idleStateNetworkIdle != newNetIdle) {
        idleStateNetworkIdle = newNetIdle;
        dispatchChangeNotification();
    }

    self.lastNetCount = newNetCount;
}


static void dispatchChangeNotification() {
    dispatchAsyncMainThread(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:IdleStateChangedNotification object:nil];
    });
}


static u_int32_t getTotalSentAndReceived() {
    struct ifaddrs * addrs = NULL;
    int err = getifaddrs(&addrs);
    if (err != 0) {
        NSLogWarn(@"Failed to get network interfaces: %s", strerror(errno));
        return 0;
    }

    u_int32_t result = 0;

    const struct ifaddrs * cursor = addrs;
    while (cursor != NULL) {
        // Names of interfaces: en0 is WiFi, pdp_ip0 is WWAN
        if (cursor->ifa_addr->sa_family == AF_LINK &&
            (hasPrefix(cursor->ifa_name, "en") || hasPrefix(cursor->ifa_name, "pdp_ip"))) {
            const struct if_data * networkStats = (const struct if_data *)cursor->ifa_data;
            result += networkStats->ifi_obytes;
            result += networkStats->ifi_ibytes;
        }

        cursor = cursor->ifa_next;
    }

    freeifaddrs(addrs);

    return result;
}


static bool hasPrefix(char * str, char * prefix) {
    return 0 == strncmp(str, prefix, strlen(prefix));
}


@end
