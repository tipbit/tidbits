//
//  DNSQueryTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 9/29/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DNSQuery.h"
#import "TBTestCaseBase.h"


@interface DNSQueryTests : TBTestCaseBase <DNSQueryDelegate>

@property (nonatomic, strong) NSArray* dnsResult;
@property (nonatomic, strong) NSError* dnsError;

@end


@implementation DNSQueryTests


-(void)testMXQuery {
    NSString* queryDomain = @"gmail.com";

    if (!isReachable(queryDomain)) {
        NSLog(@"%s: Skipping test; %@ not reachable.", __PRETTY_FUNCTION__, queryDomain);
        return;
    }

    DNSQuery* q = [[DNSQuery alloc] init:queryDomain rrtype:ns_t_mx delegate:self];
    self.dnsResult = nil;
    self.dnsError = nil;
    [q start];
    XCTAssert(WaitFor(^bool { return self.dnsResult != nil || self.dnsError != nil; }), @"Timed out");
    XCTAssert(self.dnsError == nil);
    XCTAssert(self.dnsResult != nil);
    XCTAssert(self.dnsResult.count > 0);
    for (id qr_ in self.dnsResult) {
        XCTAssert([qr_ isKindOfClass:[DNSQueryResult class]]);

        DNSQueryResult* qr = qr_;
        XCTAssertEqual(qr.rrtype, ns_t_mx);
        XCTAssert([qr.fullname isEqualToString:queryDomain]);
        XCTAssert([qr.name hasSuffix:@"google.com"] || [qr.name hasSuffix:@"googlemail.com"]);
        XCTAssert(qr.preference > 0);
    }
}


-(void)testMXQueryInvalid {
    NSString* queryDomain = @"notarealdomain.io";

    DNSQuery* q = [[DNSQuery alloc] init:queryDomain rrtype:ns_t_mx delegate:self];
    self.dnsResult = nil;
    self.dnsError = nil;
    [q start];
    XCTAssert(WaitFor(^bool { return self.dnsResult != nil || self.dnsError != nil; }), @"Timed out");
    XCTAssert(self.dnsError != nil);
    XCTAssert(self.dnsResult == nil);
    XCTAssertEqualObjects(self.dnsError.domain, DNSQueryErrorDomain);
    XCTAssertEqual(self.dnsError.code, DNSQueryNoSuchDomain);
}


-(void)dnsQuery:(DNSQuery *)dnsQuery succeededWithResult:(NSArray *)result {
    self.dnsResult = result;
}


-(void)dnsQuery:(DNSQuery *)dnsQuery failedWithError:(NSError *)error {
    self.dnsError = error;
}


@end
