//
//  NSBundle+Versions.h
//  Tidbits
//
//  Created by Ewan Mellor on 8/2/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Versions)

-(NSString*)bundleName;
-(NSString*)userAgent;
-(NSString*)versionString;

@end
