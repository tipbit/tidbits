//
//  NSArray+Map.h
//  TBClientLib
//
//  Created by Ewan Mellor on 5/5/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StandardBlocks.h"

@interface NSArray (Map)

/*!
 * @abstract Create a new NSArray with the contents set to x for each x in self
 * where filter(x) returns true.
 */
-(NSArray*)filter:(predicate_t)filter;

/*!
 * @abstract Create a new NSArray with the contents set to mapper(x) for each x in self.
 *
 * @discussion mapper may return nil, in which case no entry is added to the result
 * (i.e. the result will be shorter than self).
 */
-(NSArray*) map:(id_to_id_t)mapper;

/*!
 * @abstract Create a new NSMutableArray with the contents determined by calls to mapper
 * for each x in self.
 *
 * @discussion This is designed for a continuation-passing style where each call to
 * mapper is serialised, and they are chained from one to the next.  mapper(x, callback)
 * is called for each x in self, and mapper should call callback(new_x) with the value
 * to be added to the result of this call.  mapper may call callback(nil), in which case
 * no entry is added to the result (i.e. the result will be shorter than self).
 * Once all the mapper calls have been made, the complete list is passed back to onSuccess.
 *
 * This call does no threading of its own, but it is expected that the mapper
 * call may go off onto another thread to do its work.  This call is completely thread-safe,
 * with the caveat that you must not modify self or its contents for the duration of the
 * call.
 */
-(void) map_async:(id_to_id_async_t)mapper onSuccess:(NSMutableArrayBlock)onSuccess;

/**
 * @abstract Create a new NSMutableDictionary with the contents set to k -> mapper(k) for each k in self.
 *
 * @discussion mapper may return nil, in which case no entry is added to the result
 * (i.e. the result will be smaller than self).
 *
 * Another way to think about this is as [NSMutableDictionary dictionaryWithObjects:[self map:mapper] forKeys:self],
 * with the exception of the behavior described above when mapper returns nil.
 */
-(NSMutableDictionary*)dictionaryWithKeysAndMappedValues:(id_to_id_t)mapper;

/**
 * @abstract Create a new NSMutableDictionary with the contents set to k -> @[v1, ..., vn], where k = mapper(v) for each v in self.
 * @[v1, ..., vn] here denotes an NSMutableArray with all values in self that are mapped to that particular key.
 *
 * @discussion mapper may return nil, in which case no entry is added to the result
 * (i.e. the result will be smaller than self).
 */
-(NSMutableDictionary *)dictionaryWithValuesAndMappedKeys:(id_to_id_t)mapper;

@end
