//
//  NSMutableData+UTF8.h
//  wbxml-ios
//
//  Created by Ewan Mellor on 4/22/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableData (UTF8)

-(void) appendUTF8:(NSString *)s;
-(void) appendUTF8Format:(NSString *)s, ...;

@end
