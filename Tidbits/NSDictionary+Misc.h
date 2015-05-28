//
//  NSDictionary+Misc.h
//  TBClientLib
//
//  Created by Ewan Mellor on 5/30/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Misc)

/**
 * @return One of the keys in this dictionary, or nil if it contains no entries.
 * The key returned is chosen at the dictionary's convenience —- the selection is not guaranteed to be random.
 */
@property (nonatomic, readonly) id<NSCopying> anyKey;

/**
 * @return One of the values in this dictionary, or nil if it contains no entries.
 * The value returned is chosen at the dictionary's convenience —- the selection is not guaranteed to be random.
 */
@property (nonatomic, readonly) id anyValue;

-(bool) boolForKey:(id)key withDefault:(bool)def;
-(double)doubleForKey:(id)key withDefault:(double)def;
-(id) objectForKey:(id)key withDefault:(id)def;
-(NSInteger)intForKey:(id)key withDefault:(NSInteger)def;
-(NSUInteger)uintForKey:(id)key withDefault:(NSUInteger)def;
-(NSArray*) arrayForKey:(id)key;
-(NSDictionary*) dictForKey:(id)key;
-(NSNumber *)numberForKey:(id)key;
-(NSString*) stringForKey:(id)key;

-(NSString *)toJSON;

/**
 * Write this NSDictionary as an XML plist.
 *
 * This is effectively the same as [self writeToFile:atomically:] only with an API that makes sense.
 */
-(BOOL)writeToFile:(NSString *)path options:(NSDataWritingOptions)options error:(NSError *__autoreleasing *)error;

@end
