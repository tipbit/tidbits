//
//  StandardBlocks.h
//  Tidbits
//
//  Created by Ewan Mellor on 6/13/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <UIKit/UIApplication.h>

#ifndef Tidbits_StandardBlocks_h
#define Tidbits_StandardBlocks_h

//http://fuckingblocksyntax.com/
//How Do I Declare A Block in Objective-C?
//    As a local variable:
//        returnType (^blockName)(parameterTypes) = ^returnType(parameters) {...};
//    As a property:
//        @property (nonatomic, copy) returnType (^blockName)(parameterTypes);
//    As a method parameter:
//        - (void)someMethodThatTakesABlock:(returnType (^)(parameterTypes))blockName;
//    As an argument to a method call:
//        [someObject someMethodThatTakesABlock: ^returnType (parameters) {...}];

typedef void (^BOOLBlock)(BOOL flag);
typedef void (^BOOLPtrBlock)(BOOL *flag);
typedef void (^BoolBlock)(bool flag);
typedef void (^IdBlock)(id obj);
typedef void (^IdIdBlock)(id obj1, id obj2);
typedef void (^IdIdIdBlock)(id obj1, id obj2, id obj3);
typedef void (^IdIdIdPtrBoolPtrBlock)(id obj1, id obj2, id* result, bool* done);
typedef void (^NSArrayBlock)(NSArray* array);
typedef void (^NSArrayBoolBlock)(NSArray* array, bool done);
typedef void (^NSArrayNSErrorBlock)(NSArray* array, NSError* error);
typedef void (^NSDictionaryNSErrorBlock)(NSDictionary* dict, NSError* error);
typedef void (^NSDataBlock)(NSData* data);
typedef void (^NSDataNSErrorBlock)(NSData* data, NSError* error);
typedef void (^NSDateBlock)(NSDate* date);
typedef void (^NSDictionaryBlock)(NSDictionary* dict);
typedef void (^NSErrorBlock)(NSError* error);
typedef void (^NSIntegerBlock)(NSInteger i);
typedef void (^NSMutableArrayBlock)(NSMutableArray* array);
typedef void (^NSObjectBlock)(NSObject * obj);
typedef void (^NSOperationQueueBlock)(NSOperationQueue* queue);
typedef void (^NSStringBlock)(NSString* str);
typedef void (^NSStringNSArrayBlock)(NSString* str, NSArray* array);
typedef void (^NSStringNSArrayNSArrayBlock)(NSString* str, NSArray* array1, NSArray* array2);
typedef void (^NSStringNSErrorBlock)(NSString* str, NSError* error);
typedef void (^NSString2Block)(NSString* str1, NSString* str2);
typedef void (^NSUIntegerBlock)(NSUInteger i);
typedef void (^NSURLBlock)(NSURL* url);
typedef void (^UIActionSheetBlock)(UIActionSheet *sheet);
typedef void (^UIBackgroundFetchResultBlock)(UIBackgroundFetchResult result);
typedef void (^VoidBlock)(void);

typedef bool (^GetBoolBlock)();
typedef id (^GetIdBlock)();
typedef NSArray* (^GetNSArrayBlock)();

typedef id (^id_to_id_t)(id obj);
typedef void (^id_to_id_async_t)(id obj, IdBlock onSuccess);
typedef bool (^predicate_t)(id obj);

#endif
