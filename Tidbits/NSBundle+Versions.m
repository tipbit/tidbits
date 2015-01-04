//
//  NSBundle+Versions.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/2/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSBundle+Versions.h"

@implementation NSBundle (Versions)


-(NSString *)bundleName {
    NSDictionary* d = self.infoDictionary;
    NSString* n = d[@"CFBundleName"];
    if (n == nil) {
        // XCTest in Xcode 6.1 needs this (I'm sure that CFBundleName was present in XCTest in Xcode 5).
        return d[@"CFBundleExecutable"];
    }
    else {
        return n;
    }
}


-(NSString *)userAgent {
    NSString * n = [self bundleName];
    NSString * v = [self versionString];
    return [NSString stringWithFormat:@"%@/%@", n, v];
}


-(NSString*)versionString {
    NSDictionary* d = self.infoDictionary;
    NSString *s = d[@"CFBundleShortVersionString"];
    NSString *b = d[@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@.%@", s, b];
}


@end
