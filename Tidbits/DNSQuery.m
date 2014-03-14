//
//  DNSQuery.m
//  Tidbits
//
//  Created by Ewan Mellor on 9/29/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#include <dns_util.h>
#include <errno.h>
#include <netdb.h>
#include <resolv.h>

#import "Dispatch.h"

#import "DNSQuery.h"


NSString* const DNSQueryErrorDomain = @"DNSQueryErrorDomain";
NSString* const kDNSQueryServiceFailureCode = @"DNSQueryServiceFailureCode";


@implementation DNSQuery {
    NSString* fullname;
    ns_type queryRrtype;
    id<DNSQueryDelegate> __weak delegate;

    /**
     * DNSQueryResult array.
     */
    NSMutableArray* result;
}


-(instancetype)init:(NSString*)fullname_ rrtype:(ns_type)rrtype delegate:(id<DNSQueryDelegate>)delegate_ {
    self = [super init];
    if (self) {
        fullname = [fullname_ copy];
        queryRrtype = rrtype;
        delegate = delegate_;
        result = [NSMutableArray array];
    }
    return self;
}


-(void)start {
    DNSQuery* __weak weakSelf = self;
    dispatchAsyncBackgroundThread(DISPATCH_QUEUE_PRIORITY_DEFAULT, ^{
        [weakSelf run];
    });
}


-(void)run {
    unsigned char response[NS_PACKETSZ];
    char buf[4096];
    ns_msg handle;

    // Append a dot to the fullname, so that res_search doesn't append the local domain part or search parent domains
    // (RES_DEFNAMES, RES_DNSRCH).
    NSString* fullname_dot = [NSString stringWithFormat:@"%@.", fullname];
    const char* fullname_s = [fullname_dot UTF8String];
    if (fullname_s == NULL) {
        [self fail:[NSError errorWithDomain:DNSQueryErrorDomain code:DNSQueryBadArgument userInfo:@{@"fullname": fullname}]];
        return;
    }

    int len = res_search(fullname_s, ns_c_in, queryRrtype, response, sizeof(response));
    if (len < 0) {
        if (h_errno == HOST_NOT_FOUND)
            [self fail:[NSError errorWithDomain:DNSQueryErrorDomain code:DNSQueryNoSuchDomain userInfo:@{@"fullname": fullname}]];
        else
            [self failWithServiceError:errno];
        return;
    }

    int err = ns_initparse(response, len, &handle);
    if (err < 0) {
        [self failWithServiceError:len];
        return;
    }

    int msg_count = ns_msg_count(handle, ns_s_an);
    if (msg_count < 0) {
        [self failWithServiceError:msg_count];
        return;
    }

    for (int msg_idx = 0; msg_idx < msg_count; msg_idx++) {
        ns_rr rr;
        if (ns_parserr(&handle, ns_s_an, msg_idx, &rr)) {
            [self fail:[NSError errorWithDomain:DNSQueryErrorDomain code:DNSQueryBadResponse userInfo:nil]];
            return;
        }

        const u_char * rdata = ns_rr_rdata(rr);

        DNSQueryResult* qr = [[DNSQueryResult alloc] init];
        qr.fullname = fullname;
        qr.rrtype = ns_rr_type(rr);
        qr.ttl = ns_rr_ttl(rr);

        if (qr.rrtype == ns_t_mx) {
            len = dn_expand(ns_msg_base(handle), ns_msg_base(handle) + ns_msg_size(handle), rdata + NS_INT16SZ, buf, sizeof(buf));
            if (len < 0) {
                [self fail:[NSError errorWithDomain:DNSQueryErrorDomain code:DNSQueryBadResponse userInfo:nil]];
                return;
            }
            
            qr.name = [NSString stringWithUTF8String:buf];
            qr.preference = (uint16_t)ns_get16(rdata);
        }

        [result addObject:qr];
    }

    [self succeed];
}


-(void)succeed {
    DNSQuery* __weak weakSelf = self;
    dispatchAsyncMainThread(^{
        DNSQuery* myself = weakSelf;
        if (myself == nil)
            return;
        id<DNSQueryDelegate> d = myself->delegate;
        if (d == nil)
            return;
        [d dnsQuery:myself succeededWithResult:myself->result];
    });
}


-(void)fail:(NSError*)error {
    DNSQuery* __weak weakSelf = self;
    dispatchAsyncMainThread(^{
        DNSQuery* myself = weakSelf;
        if (myself == nil)
            return;
        id<DNSQueryDelegate> d = myself->delegate;
        if (d == nil)
            return;
        [d dnsQuery:myself failedWithError:error];
    });
}


-(void)failWithServiceError:(int)code {
    [self fail:[NSError errorWithDomain:DNSQueryErrorDomain code:DNSQueryServiceFailure userInfo:@{kDNSQueryServiceFailureCode: @(code)}]];
}


@end


@implementation DNSQueryResult

@end
