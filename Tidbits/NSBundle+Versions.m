//
//  NSBundle+Versions.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/2/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSBundle+Versions.h"

@implementation NSBundle (Versions)


+(NSString*)userAgent {
    return [[NSBundle mainBundle] userAgent];
}


+(NSString*)versionString {
    return [[NSBundle mainBundle] versionString];
}


-(NSString*)userAgent {
    NSDictionary* d = self.infoDictionary;
    NSString* n = d[@"CFBundleName"];
    NSString* v = [self versionString];
    return [NSString stringWithFormat:@"%@/%@", n, v];
}


-(NSString*)versionString {
    NSDictionary* d = self.infoDictionary;
    NSString *s = d[@"CFBundleShortVersionString"];
    NSString *b = d[@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@.%@", s, b];
}


@end
