//
//  CPUTime.m
//  Tidbits
//
//  Created by Ewan Mellor on 4/7/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#include <mach/mach_host.h>
#include <mach/mach_error.h>
#include <mach/thread_act.h>

#import "LoggingMacros.h"

#import "CPUTime.h"


bool cpu_time_get(CPUTime *result) {
    mach_msg_type_number_t count = THREAD_BASIC_INFO_COUNT;
    thread_basic_info_data_t thread_data;

    kern_return_t error = thread_info(mach_thread_self(), THREAD_BASIC_INFO, (thread_info_t)&thread_data, &count);
    if (error != KERN_SUCCESS) {
        NSLog(@"thread_info failed: %s", mach_error_string(error));
        result->user_time = 0.0;
        result->system_time = 0.0;
        return false;
    }

    result->user_time = thread_data.user_time.seconds + thread_data.user_time.microseconds * 1e-6;
    result->system_time = thread_data.system_time.seconds + thread_data.system_time.microseconds * 1e-6;
    return true;
}
