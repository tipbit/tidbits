//
//  NSArray+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 10/3/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Misc)

-(NSDictionary*)dictAtIndex:(NSUInteger)index;

-(id)objectAtIndex:(NSUInteger)index withDefault:(id)def;

-(NSArray*)componentsJoinedByString:(NSString*)separator inBatches:(NSUInteger)batchSize;

@end
