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

/**
 * @return true if anything was removed.
 */
-(BOOL)removeEntriesPassingTest:(BOOL (^)(id key, id val, BOOL * stop))predicate;

/**
 * Read an NSMutableDictionary from the given file, assuming that it is a plist.
 *
 * This is effectively the same as [NSMutableDictionary dictionaryWithContentsOfFile:]
 * only it reports any errors too.
 */
+(NSMutableDictionary *)dictionaryWithContentsOfFile:(NSString *)path error:(NSError *__autoreleasing *)error;

@end
