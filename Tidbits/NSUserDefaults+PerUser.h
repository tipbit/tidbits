//
//  NSUserDefaults+PerUser.h
//  TBClientLib
//
//  Created by Nat Ballou on 9/26/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (PerUser)

+(NSString*)PUKey:(NSString*) key;
+(NSString*)PUKey:(NSString*) key user:(NSString*) TBUser;
+(BOOL)getPUFlag:(NSString*)key;
+(void)setPUFlag:(BOOL)value forKey:(NSString*)key;

@end
