//
//  TBTestCaseBase.m
//  Tidbits
//
//  Created by Ewan Mellor on 10/9/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "LogFormatter.h"
#import "LoggingMacros.h"
#import "NSString+Misc.h"
#import "NSUserDefaults+Misc.h"

#import "TBJUnitTestObserver.h"

#import "TBTestCaseBase.h"


@implementation TBTestCaseBase


+(void)load {
    NSUserDefaults * defaults = [NSUserDefaults tb_standardUserDefaults];
    NSString * observers = [defaults stringForKey:@"XCTestObserverClass"];
    NSString * className = NSStringFromClass([TBJUnitTestObserver class]);
    if (observers == nil) {
        observers = @"XCTestLog";
    }
    else if (![observers contains:className]) {
        observers = [NSString stringWithFormat:@"%@,%@", observers, className];
    }
    [defaults setValue:observers forKey:@"XCTestObserverClass"];
}


+(void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [LogFormatter formatterRegisteredAsDefaultASLAndTTYUsingTTYFormatter:NO];
    });
}


-(void)setUp {
    NSLog(@"%@", self);

    [super setUp];
    self.continueAfterFailure = NO;
}


-(void)tearDown {
    NSLog(@"%@", self);
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
