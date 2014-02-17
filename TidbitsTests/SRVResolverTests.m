//
//  SRVResolverTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 11/5/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import "NSDictionary+Misc.h"
#import "SRVResolver.h"

#import "TBTestCaseBase.h"


@interface SRVResolverTests : TBTestCaseBase <SRVResolverDelegate>

@property (nonatomic, strong) NSArray* results;
@property (nonatomic, strong) NSError* error;

@end


@implementation SRVResolverTests


-(void)NETWORKED_TEST(testSRVResolverAutodiscoverSmartertools) {
    [self runSRVResolver:@"_autodiscover._tcp.smartertools.com"];

    XCTAssert(self.error == nil, @"%@", self.error);
    XCTAssert(self.results.count > 0);
    for (NSDictionary* result in self.results) {
        XCTAssert([result intForKey:@"priority" withDefault:-1] == 0);
        XCTAssert([result intForKey:@"weight" withDefault:-1] == 0);
        XCTAssert([result intForKey:@"port" withDefault:-1] == 443);
        XCTAssert([[result stringForKey:@"target"] isEqualToString:@"mail.smartertools.com"]);
    }
}


// We don't have an autodiscover SRV record configured, so this should fail.
-(void)NETWORKED_TEST(testSRVResolverAutodiscoverTipbit) {
    [self runSRVResolver:@"_autodiscover._tcp.tipbit.com"];

    XCTAssert(self.error != nil);
    XCTAssert(self.results.count == 0);
}


-(void)runSRVResolver:(NSString*)name {
    self.results = nil;
    self.error = nil;
    SRVResolver* resolver = [[SRVResolver alloc] initWithSRVName:name];
    resolver.delegate = self;
    [resolver start];
    WaitFor(^bool{ return self.results != nil || self.error != nil; });
}


-(void)srvResolver:(SRVResolver *)resolver didStopWithError:(NSError *)error {
    self.results = resolver.results;
    self.error = error;
}


@end
