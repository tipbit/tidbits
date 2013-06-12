//
//  NSMutableArray+Stack.m
//  wbxml-ios
//
//  Created by Ewan Mellor on 4/22/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (Stack)

-(void) push:(id)item {
    [self addObject:item];
}

-(id) pop {
    id result = nil;
    if ([self count] != 0) {
        result = [self lastObject];
        [self removeLastObject];
    }
    return result;
}

-(id) peek {
    return [self count] != 0 ? [self lastObject] : nil;
}

@end


@implementation NSMutableArray (Deque)

-(void) pushFront:(id)item {
    [self addObject:item];
}

-(void) pushBack:(id)item {
    [self insertObject:item atIndex:0];
}

-(id) popFront {
    id result = nil;
    if ([self count] != 0) {
        result = [self lastObject];
        [self removeLastObject];
    }
    return result;
}

-(id) peekFront {
    return [self count] != 0 ? [self lastObject] : nil;
}

@end
