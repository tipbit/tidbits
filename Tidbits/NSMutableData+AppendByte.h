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
-(void) appendUint16:(u_int16_t)i;
-(void) appendUint32:(u_int32_t)i;

@end
