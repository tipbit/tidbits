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

@end


@implementation DNSQueryTests {
    NSArray* dnsResult;
    NSError* dnsError;
}


-(void)testMXQuery {
    NSString* queryDomain = @"gmail.com";

    if (!isReachable(queryDomain)) {
        NSLog(@"%s: Skipping test; %@ not reachable.", __PRETTY_FUNCTION__, queryDomain);
        return;
    }

    DNSQuery* q = [[DNSQuery alloc] init:queryDomain rrtype:ns_t_mx delegate:self];
    dnsResult = nil;
    dnsError = nil;
    [q start];
    XCTAssert(WaitFor(^bool { return dnsResult != nil || dnsError != nil; }), @"Timed out");
    XCTAssert(dnsError == nil);
    XCTAssert(dnsResult != nil);
    XCTAssert(dnsResult.count > 0);
    for (id qr_ in dnsResult) {
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
    dnsResult = nil;
    dnsError = nil;
    [q start];
    XCTAssert(WaitFor(^bool { return dnsResult != nil || dnsError != nil; }), @"Timed out");
    XCTAssert(dnsError != nil);
    XCTAssert(dnsResult == nil);
    XCTAssertEqualObjects(dnsError.domain, DNSQueryErrorDomain);
    XCTAssertEqual(dnsError.code, DNSQueryNoSuchDomain);
}


-(void)dnsQuery:(DNSQuery *)dnsQuery succeededWithResult:(NSArray *)result {
    dnsResult = result;
}


-(void)dnsQuery:(DNSQuery *)dnsQuery failedWithError:(NSError *)error {
    dnsError = error;
}


@end
