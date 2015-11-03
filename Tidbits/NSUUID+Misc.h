//
//  NSUUID+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 10/5/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/NSString.h>
#import <Foundation/NSUUID.h>

@interface NSUUID (Misc)

-(NSString*)UUIDStringBase64url;

+(NSUUID *)UUIDFromBase64urlString:(NSString *)str;

@end
