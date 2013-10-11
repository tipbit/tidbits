//
//  NSDictionary+Misc.h
//  TBClientLib
//
//  Created by Ewan Mellor on 5/30/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Misc)

-(bool) boolForKey:(id)key withDefault:(bool)def;
-(id) objectForKey:(id)key withDefault:(id)def;
-(NSInteger)intForKey:(id)key withDefault:(NSUInteger)def;
-(NSUInteger)uintForKey:(id)key withDefault:(NSUInteger)def;
-(NSArray*) arrayForKey:(id)key;
-(NSDictionary*) dictForKey:(id)key;
-(NSNumber *)numberForKey:(id)key;
-(NSString*) stringForKey:(id)key;

@end
