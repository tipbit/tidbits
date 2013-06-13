//
//  StandardBlocks.h
//  Tidbits
//
//  Created by Ewan Mellor on 6/13/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#ifndef Tidbits_StandardBlocks_h
#define Tidbits_StandardBlocks_h

typedef void (^NSArrayBlock)(NSArray* array);
typedef void (^NSDataBlock)(NSData* data);
typedef void (^NSDictionaryBlock)(NSDictionary* dict);
typedef void (^NSErrorBlock)(NSError* error);
typedef void (^NSStringBlock)(NSString* str);
typedef void (^NSUIntegerBlock)(NSUInteger i);
typedef void (^VoidBlock)(void);


#endif
