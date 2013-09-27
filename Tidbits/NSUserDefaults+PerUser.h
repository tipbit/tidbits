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
+(BOOL)getPUBool:(NSString*)key;
+(void)setPUBool:(BOOL)value forKey:(NSString*)key;
+(NSString*)getPUString:(NSString*)key;
+(void)setPUString:(NSString*)value forKey:(NSString*)key;

@end
