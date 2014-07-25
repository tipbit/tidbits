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

-(bool)isNetworkError;
-(bool)isNoSuchFile;

-(NSString *)message;

@end
