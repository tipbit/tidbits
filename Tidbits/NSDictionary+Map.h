//
//  NSDictionary+Map.h
//  TBClientLib
//
//  Created by Ewan Mellor on 5/23/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Map)

typedef id (^key_val_to_id_t)(id key, id val);

/**
 * Create a new NSArray with the contents set to mapper(k, v) for each k,v pair in self.
 *
 * mapper may return nil, in which case no entry is added to the result
 * (i.e. the result will be shorter than self).
 */
-(NSMutableArray *)map:(key_val_to_id_t)mapper;

/**
 * Create a new NSMutableDictionary with the contents set to k -> mapper(k, v) for each k,v pair in self.
 *
 * @param mapper may return nil, in which case no entry is added to the result
 * (i.e. the result will be shorter than self).
 */
-(NSMutableDictionary *)dictionaryWithKeysAndMappedValues:(key_val_to_id_t)mapper;

/**
 * Create a new NSMutableDictionary with the contents set to m -> @[v1, ..., vn],
 * where m = mapper(k, v) for each k,v pair in self.
 * @[v1, ..., vn] here denotes an NSMutableArray with all values in self that are mapped to that particular key.
 *
 * @param mapper May return nil, in which case no entry is added to the result
 * (i.e. the result will be shorter than self).
 */
-(NSMutableDictionary *)dictionaryWithValuesAndMappedKeys:(key_val_to_id_t)mapper;

/**
 * Create a new NSMutableDictionary with the contents set to keyMapper(k, v) -> valueMapper(k, v) for each k,v pair in self.
 *
 * @param keyMapper may return nil, in which case no entry is added to the result
 * (i.e. the result will be shorter than self).
 * @param valueMapper may return nil, in which case no entry is added to the result
 * (i.e. the result will be shorter than self).
 */
-(NSMutableDictionary *)dictionaryWithMappedKeysAndMappedValues:(key_val_to_id_t)keyMapper valueMapper:(key_val_to_id_t)valueMapper;

@end
