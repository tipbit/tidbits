//
//  NSDictionary+Map.m
//  TBClientLib
//
//  Created by Ewan Mellor on 5/23/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSDictionary+Map.h"


@implementation NSDictionary (Map)


-(NSMutableArray *)map:(key_val_to_id_t)mapper {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL *stop) {
        id new_obj = mapper(key, val);
        if (new_obj != nil) {
            [result addObject: new_obj];
        }
    }];
    return result;
}


-(NSMutableDictionary *)dictionaryWithKeysAndMappedValues:(key_val_to_id_t)mapper {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL *stop) {
        id new_obj = mapper(key, val);
        if (new_obj != nil) {
            result[key] = new_obj;
        }
    }];
    return result;
}


-(NSMutableDictionary *)dictionaryWithValuesAndMappedKeys:(key_val_to_id_t)mapper {
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL *stop) {
        id new_key = mapper(key, val);
        if (new_key != nil) {
            NSMutableArray* arr = result[new_key];
            if (arr == nil) {
                arr = [NSMutableArray array];
                result[new_key] = arr;
            }
            [arr addObject:val];
        }
    }];
    return result;
}


-(NSMutableDictionary *)dictionaryWithMappedKeysAndMappedValues:(key_val_to_id_t)keyMapper valueMapper:(key_val_to_id_t)valueMapper {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL *stop) {
        id new_key = keyMapper(key, val);
        id new_val = valueMapper(key, val);
        if (new_key != nil && new_val != nil) {
            result[new_key] = new_val;
        }
    }];
    return result;
}


@end
