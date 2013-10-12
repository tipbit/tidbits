//
//  NSData+SHA256.h
//  Tidbits
//
//  Created by Ewan Mellor on 10/11/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SHA256)

-(NSString*)sha256;
-(NSData*)sha256Data;

@end
