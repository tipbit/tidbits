//
//  NSMutableData+AppendByte.h
//  wbxml-ios
//
//  Created by Ewan Mellor on 4/25/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableData (AppendByte)

-(void) appendByte:(u_int8_t)b;

@end
