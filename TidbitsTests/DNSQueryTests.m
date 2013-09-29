//
//  DNSQueryTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 9/29/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DNSQuery.h"


#define TIMEOUT 10


@interface DNSQueryTests : XCTestCase <DNSQueryDelegate>

@end


@implementation DNSQueryTests {
    NSArray* dnsResult;
    NSError* dnsError;
}


-(void)testMXQuery {
    NSString* queryDomain = @"gmail.com";
    DNSQuery* q = [[DNSQuery alloc] init:queryDomain rrtype:kDNSServiceType_MX delegate:self];
    dnsResult = nil;
    dnsError = nil;
    [q start];
    XCTAssert(WaitFor(^BOOL { return dnsResult != nil || dnsError != nil; }), @"Timed out");
    XCTAssert(dnsError == nil);
    XCTAssert(dnsResult != nil);
    for (id qr_ in dnsResult) {
        XCTAssert([qr_ isKindOfClass:[DNSQueryResult class]]);

        DNSQueryResult* qr = qr_;
        XCTAssertEqual(qr.rrtype, (uint16_t)kDNSServiceType_MX);
        XCTAssert([qr.fullname isEqualToString:queryDomain]);
        XCTAssert([qr.name hasSuffix:@"google.com"] || [qr.name hasSuffix:@"googlemail.com"]);
        XCTAssert(qr.preference > 0);
    }
}


-(void)dnsQuery:(DNSQuery *)dnsQuery succeededWithResult:(NSArray *)result {
    dnsResult = result;
}


-(void)dnsQuery:(DNSQuery *)dnsQuery failedWithError:(NSError *)error {
    dnsError = error;
}


BOOL WaitFor(BOOL (^block)(void))
{
    NSTimeInterval start = [[NSProcessInfo processInfo] systemUptime];
    while(!block() && [[NSProcessInfo processInfo] systemUptime] - start <= TIMEOUT)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
    return block();
}


@end
