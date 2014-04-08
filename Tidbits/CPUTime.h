//
//  CPUTime.h
//  Tidbits
//
//  Created by Ewan Mellor on 4/7/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

typedef struct {
    double user_time;
    double system_time;
} CPUTime;

extern bool cpu_time_get(CPUTime *result);
