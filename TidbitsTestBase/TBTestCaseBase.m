//
//  TBTestCaseBase.m
//  Tidbits
//
//  Created by Ewan Mellor on 10/9/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "LogFormatter.h"

#import "TBTestCaseBase.h"


@implementation TBTestCaseBase


+(void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [LogFormatter formatterRegisteredAsDefaultASLAndTTYUsingTTYFormatter:NO];
    });
}


-(void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
}


-(void)tearDown {
    [DDLog flushLog];
    [super tearDown];
}


-(NSDictionary*)loadJSONDictFromBundle:(NSString*)resourceName {
    id result = [self loadJSONFromBundle:resourceName];
    XCTAssert([result isKindOfClass:[NSDictionary class]]);
    return result;
}


-(id)loadJSONFromBundle:(NSString*)resourceName {
    NSError* err = nil;

    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:resourceName ofType:@"json"];
    NSData* data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&err];
    XCTAssertNotNil(data);
    XCTAssertNil(err);

    id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    if (obj == nil)
        NSLog(@"Failed to deserialize %@: %@", resourceName, err);
    XCTAssertNotNil(obj);
    XCTAssertNil(err);

    return obj;
}


@end
