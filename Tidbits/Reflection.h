//
//  Reflection.h
//  Tidbits
//
//  Created by Ewan Mellor on 8/21/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StandardBlocks.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum {
    ReflectionMatchDoNotCare,
    ReflectionMatchRequireNo,
    ReflectionMatchRequireYes,
} ReflectionMatch;


/**
 * @param predicate A predicate that is applied to the attribute declaration string of each property
 * (c.f. property_getAttributes).  Return YES to include the property in the result.
 * @return NSString array.  The names of each property in the full class heirarchy that match the given predicate.
 */
extern NSMutableArray * reflectionGetPropertyNames(Class cls, CStringGetBoolBlock __nullable predicate);

extern BOOL reflectionPropertyAttributeStringMatches(const char * attributeString, ReflectionMatch isObject, ReflectionMatch isReadonly, ReflectionMatch isWeak);


NS_ASSUME_NONNULL_END
