//
//  NSMutableDictionary+Misc.h
//  TBClientLib
//
//  Created by Ewan Mellor on 5/2/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Misc)

-(void) addIfSet:(id)value forKey:(id<NSCopying>)key;

-(void) addIfSetIn:(NSDictionary*)source forKey:(id<NSCopying>)key;

-(void) addKeyIfSet:(id<NSCopying>)key value:(id)value;

-(void) mergeLeft:(NSDictionary*)dict;

@end
