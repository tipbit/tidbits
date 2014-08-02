//
//  NSObject+MTJSONUtils.h
//  MTJSONUtils
//
//  Created by Adam Kirk on 8/16/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MTJSONUtils)

- (NSData *)JSONData;
- (id)objectWithJSONSafeObjects;
- (id)valueForComplexKeyPath:(NSString *)keyPath;
- (NSString *)stringValueForComplexKeyPath:(NSString *)key;

@end

