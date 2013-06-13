//
//  NSUserDefaults+Default.h
//  TBClientLib
//
//  Created by Ewan Mellor on 5/16/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Default)

-(NSString*)stringForKey:(NSString *)defaultName defaultValue:(NSString*)def;

@end
