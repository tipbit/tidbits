//
//  NSMutableArray+Stack.h
//  wbxml-ios
//
//  Created by Ewan Mellor on 4/22/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Stack)

-(void) push:(id)item;
-(id) pop;
-(id) peek;

@end

@interface NSMutableArray (Deque)

-(void) pushFront:(id)item;
-(void) pushBack:(id)item;
-(id) popFront;
-(id) peekFront;

@end
