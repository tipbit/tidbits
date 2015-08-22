//
//  StandardBlocks.h
//  Tidbits
//
//  Created by Ewan Mellor on 6/13/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIApplication.h>
#endif

#ifndef Tidbits_StandardBlocks_h
#define Tidbits_StandardBlocks_h

typedef void (^BOOLBlock)(BOOL flag);
typedef void (^BOOLPtrBlock)(BOOL *flag);
typedef void (^BoolBlock)(bool flag);
typedef void (^IdBlock)(id obj);
typedef void (^IdIdBlock)(id obj1, id obj2);
typedef void (^IdIdIdBlock)(id obj1, id obj2, id obj3);
typedef void (^IdIdIdPtrBoolPtrBlock)(id obj1, id obj2, id* result, bool* done);
typedef void (^IdIdIdIdPtrBoolPtrBlock)(id obj1, id obj2, id obj3, id * result, BOOL * done);
typedef void (^NSArrayBlock)(NSArray* array);
typedef void (^NSArrayBoolBlock)(NSArray* array, bool done);
typedef void (^NSArrayNSArrayBlock)(NSArray* array1, NSArray* array2);
typedef void (^NSArrayNSDictionaryBlock)(NSArray * array, NSDictionary * dict);
typedef void (^NSArrayNSDictionary2Block)(NSArray * array, NSDictionary * dict1, NSDictionary * dict2);
typedef void (^NSArrayNSDictionary3Block)(NSArray * array, NSDictionary * dict1, NSDictionary * dict2, NSDictionary * dict3);
typedef void (^NSArrayNSErrorBlock)(NSArray* array, NSError* error);
typedef void (^NSArrayNSStringBlock)(NSArray * array, NSString * str);
typedef void (^NSOperationBlock)(NSOperation * op);
typedef void (^NSBlockOperationBlock)(NSBlockOperation * op);
typedef void (^NSDictionaryNSErrorBlock)(NSDictionary* dict, NSError* error);
typedef void (^NSDataBlock)(NSData* data);
typedef void (^NSDataNSErrorBlock)(NSData* data, NSError* error);
typedef void (^NSDataNSStringBlock)(NSData* data, NSString* str);
typedef void (^NSDateBlock)(NSDate* date);
typedef void (^NSDictionaryBlock)(NSDictionary* dict);
typedef void (^NSDictionary2Block)(NSDictionary * dict1, NSDictionary * dict2);
typedef void (^NSDictionary3Block)(NSDictionary * dict1, NSDictionary * dict2, NSDictionary * dict3);
typedef void (^NSDictionary4Block)(NSDictionary * dict1, NSDictionary * dict2, NSDictionary * dict3, NSDictionary * dict4);
typedef void (^NSErrorBlock)(NSError* error);
typedef void (^NSIntegerBlock)(NSInteger i);
typedef void (^NSIntegerBoolBlock)(NSInteger i, BOOL flag);
typedef void (^NSMutableArrayBlock)(NSMutableArray* array);
typedef void (^NSMutableDictionaryBlock)(NSMutableDictionary * dict);
typedef void (^NSObjectBlock)(NSObject * obj);
typedef void (^NSOperationQueueBlock)(NSOperationQueue* queue);
typedef void (^NSStringBlock)(NSString* str);
typedef void (^NSStringNSArrayBlock)(NSString* str, NSArray* array);
typedef void (^NSStringNSArrayNSArrayBlock)(NSString* str, NSArray* array1, NSArray* array2);
typedef void (^NSStringNSErrorBlock)(NSString* str, NSError* error);
typedef void (^NSString2Block)(NSString* str1, NSString* str2);
typedef void (^NSUIntegerBlock)(NSUInteger i);
typedef void (^NSURLBlock)(NSURL* url);
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
typedef void (^UIActionSheetBlock)(UIActionSheet *sheet);
typedef void (^UIBackgroundFetchResultBlock)(UIBackgroundFetchResult result);
typedef void (^FetchResponseBlock)(UIBackgroundFetchResult result, id email);
typedef void (^UIButtonBlock)(UIButton *button);
typedef void (^UIImageBlock)(UIImage * image);
#endif
typedef void (^VoidBlock)(void);

typedef bool (^GetBoolBlock)();
typedef id (^GetIdBlock)();
typedef NSArray* (^GetNSArrayBlock)();
typedef BOOL (^CStringGetBoolBlock)(const char * cstr);

typedef id (^id_to_id_t)(id obj);
typedef void (^id_to_id_async_t)(id obj, IdBlock onSuccess);
typedef bool (^predicate_t)(id obj);

#endif
