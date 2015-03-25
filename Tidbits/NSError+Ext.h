//
//  NSError+Ext.h
//  Tidbits
//
//  Created by Ewan Mellor on 12/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Ext)

+(id)errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)message;

-(bool)isFileReadNoPermissionError;
-(bool)isFileWriteFileExistsError;
-(bool)isFileWriteNoPermission;
-(bool)isNetworkError;
-(bool)isNoSuchFile;
-(bool)isPropertyListReadCorruptError;

-(bool)isHTTP400;
-(bool)isHTTP401;
-(bool)isHTTP403;
-(bool)isHTTP404;
-(bool)isHTTP409;
-(bool)isHTTP422;
-(bool)isHTTP50x;

-(bool)isURLErrorCancelled;

-(NSString *)message;

@end
