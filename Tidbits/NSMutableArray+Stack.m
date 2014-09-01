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
    if (self.count == 0) {
        return nil;
    }
    else {
        id result = [self lastObject];
        [self removeLastObject];
        return result;
    }
}

-(id) peek {
    return self.count == 0 ? nil : [self lastObject];
}

@end


@implementation NSMutableArray (Deque)

-(void) pushFront:(id)item {
    [self push:item];
}

-(void) pushBack:(id)item {
    [self insertObject:item atIndex:0];
}

-(id) popFront {
    return [self pop];
}

-(id) peekFront {
    return [self peek];
}

@end
