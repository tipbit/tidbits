//
//  NSFileHandle+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 3/21/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileHandle (Misc)

+(instancetype)fileHandleForReadingAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;
+(instancetype)fileHandleForUpdatingAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;
+(instancetype)fileHandleForWritingAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;

@end
