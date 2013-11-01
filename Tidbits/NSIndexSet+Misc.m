//
//  NSIndexSet+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 11/1/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <UIKit/UITableView.h>

#import "NSIndexSet+Misc.h"


@implementation NSIndexSet (Misc)


-(NSArray*)indexPathsInSection:(NSInteger)section {
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [result addObject:[NSIndexPath indexPathForRow:idx inSection:section]];
    }];
    return result;
}


@end
