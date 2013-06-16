//
//  NSMutableData+AppendByte.m
//  wbxml-ios
//
//  Created by Ewan Mellor on 4/25/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSMutableData+AppendByte.h"

@implementation NSMutableData (AppendByte)

-(void) appendByte:(u_int8_t)b {
    [self appendBytes:&b length:1];
}

-(void) appendUint16:(u_int16_t)i {
    [self appendBytes:&i length:2];
}

-(void) appendUint32:(u_int32_t)i {
    [self appendBytes:&i length:4];
}

@end
