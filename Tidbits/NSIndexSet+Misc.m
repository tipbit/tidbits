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


+(instancetype)indexSetWithIndexesInArray:(NSArray *)array {
    NSMutableIndexSet *result = [NSMutableIndexSet indexSet];
    for (NSNumber* num in array) {
        [result addIndex:num.unsignedIntegerValue];
    }
    return result;
}


-(NSArray*)indexPathsInSection:(NSInteger)section {
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [result addObject:[NSIndexPath indexPathForRow:idx inSection:section]];
    }];
    return result;
}

-(NSArray*)zeroRowIndexPathsForSections {
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [result addObject:[NSIndexPath indexPathForRow:0 inSection:idx]];
    }];
    return result;
}


@end
