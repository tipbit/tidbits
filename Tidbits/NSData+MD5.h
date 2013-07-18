//
//  NSData+MD5.h
//  Tidbits
//
//  Created by Ewan Mellor on 7/3/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MD5)

-(NSString*)md5;
-(NSData*)md5Data;

@end
