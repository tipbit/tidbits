//
//  NSError+Ext.h
//  Tidbits
//
//  Created by Ewan Mellor on 12/8/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Ext)

-(bool)isNoSuchFile;
+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)message;
- (NSString *)message;
@end
