//
//  DNSQuery.m
//  Tidbits
//
//  Created by Ewan Mellor on 9/29/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#include <dns_sd.h>
#include <dns_util.h>
#include <resolv.h>

#import "Dispatch.h"
#import "StandardBlocks.h"

#import "DNSQuery.h"


NSString* const DNSQueryErrorDomain = @"DNSQueryErrorDomain";
NSString* const kDNSServiceErrorType = @"DNSServiceErrorType";


@implementation DNSQuery {
    NSString* fullname;
    uint16_t queryRrtype;
    id<DNSQueryDelegate> __weak delegate;

    DNSServiceRef dnsServiceRef;
    CFSocketRef socketRef;

    /**
     * DNSQueryResult array.
     */
    NSMutableArray* result;
}


-(instancetype)init:(NSString*)fullname_ rrtype:(uint16_t)rrtype delegate:(id<DNSQueryDelegate>)delegate_ {
    self = [super init];
    if (self) {
        fullname = [fullname_ copy];
        queryRrtype = rrtype;
        delegate = delegate_;
        result = [NSMutableArray array];
    }
    return self;
}


-(void)dealloc {
    [self stop];
}


static void queryRecordCallback(DNSServiceRef serviceRef, DNSServiceFlags flags, uint32_t interfaceIndex,
                                DNSServiceErrorType errorCode, const char *fullname,
                                uint16_t rrtype, uint16_t rrclass,
                                uint16_t rdlen, const void *rdata,
                                uint32_t ttl, void *context);

static void socketCallback(CFSocketRef s,
                           CFSocketCallBackType type,
                           CFDataRef address,
                           const void * data,
                           void * info);


-(void)start {
    const char* fullname_s = [fullname UTF8String];
    if (fullname_s == NULL) {
        [self fail:[NSError errorWithDomain:DNSQueryErrorDomain code:DNSQueryBadArgument userInfo:@{@"fullname": fullname}]];
        return;
    }

    DNSServiceRef sdRef = NULL;
    DNSServiceErrorType error = DNSServiceQueryRecord(&sdRef, 0, kDNSServiceInterfaceIndexAny,
                                                      fullname_s, queryRrtype, kDNSServiceClass_IN,
                                                      queryRecordCallback, (__bridge void *)self);
    
    if (error != kDNSServiceErr_NoError) {
        [self failWithServiceError:error];
        return;
    }

    int fd = DNSServiceRefSockFD(sdRef);

    CFSocketContext socketContext = { 0, (__bridge void *)self, NULL, NULL, NULL };
    CFSocketRef sRef = CFSocketCreateWithNative(NULL, fd, kCFSocketReadCallBack, socketCallback, &socketContext);
    if (sRef == NULL) {
        DNSServiceRefDeallocate(sdRef);
        [self failWithServiceError:kDNSServiceErr_Unknown];
        return;
    }
    CFSocketSetSocketFlags(sRef, CFSocketGetSocketFlags(sRef) & ~(CFOptionFlags)kCFSocketCloseOnInvalidate);

    dnsServiceRef = sdRef;
    socketRef = sRef;

    CFRunLoopSourceRef runloopRef = CFSocketCreateRunLoopSource(NULL, sRef, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runloopRef, kCFRunLoopDefaultMode);
    CFRelease(runloopRef);
}


-(void)stop {
    CFSocketRef sRef = socketRef;
    socketRef = NULL;
    if (sRef != NULL) {
        CFSocketInvalidate(sRef);
        CFRelease(sRef);
    }

    DNSServiceRef serviceRef = dnsServiceRef;
    dnsServiceRef = NULL;
    if (serviceRef != NULL)
        DNSServiceRefDeallocate(serviceRef);
}


-(void)stopAndSucceed {
    [self stop];
    [self succeed];
}


-(void)stopAndFail:(NSError*)error {
    [self stop];
    [self fail:error];
}


-(void)stopAndFailWithServiceError:(DNSServiceErrorType)code {
    [self stop];
    [self failWithServiceError:code];
}


-(void)failWithServiceError:(DNSServiceErrorType)code {
    [self fail:[NSError errorWithDomain:DNSQueryErrorDomain code:DNSQueryServiceFailure userInfo:@{kDNSServiceErrorType: @(code)}]];
}


-(void)succeed {
    DNSQuery* __weak weakSelf = self;
    dispatchAsyncMainThread(^{
        id<DNSQueryDelegate> d = delegate;
        DNSQuery* myself = weakSelf;
        if (d == nil || myself == nil)
            return;
        [d dnsQuery:myself succeededWithResult:myself->result];
    });
}


-(void)fail:(NSError*)error {
    DNSQuery* __weak weakSelf = self;
    dispatchAsyncMainThread(^{
        id<DNSQueryDelegate> d = delegate;
        DNSQuery* myself = weakSelf;
        if (d == nil || myself == nil)
            return;
        [d dnsQuery:myself failedWithError:error];
    });
}


-(void)processRecord:(uint16_t)rrtype rdlen:(uint16_t)rdlen rdata:(const void *)rdata ttl:(uint32_t)ttl {
    DNSQueryResult* qr = [[DNSQueryResult alloc] init];
    qr.fullname = fullname;
    qr.rrtype = rrtype;
    qr.ttl = ttl;

    [self parseRecordData:qr rrtype:rrtype rdlen:rdlen rdata:rdata ttl:ttl];

    [result addObject:qr];
}


-(void)parseRecordData:(DNSQueryResult*)qr rrtype:(uint16_t)rrtype rdlen:(uint16_t)rdlen rdata:(const void *)rdata ttl:(uint32_t)ttl {
    NSMutableData* rrData = [NSMutableData data];
    uint8_t u8;
    uint16_t u16;
    uint32_t u32;

    u8 = 0;
    [rrData appendBytes:&u8 length:sizeof(u8)];
    u16 = htons(rrtype);
    [rrData appendBytes:&u16 length:sizeof(u16)];
    u16 = htons(kDNSServiceClass_IN);
    [rrData appendBytes:&u16 length:sizeof(u16)];
    u32 = htonl(0);
    [rrData appendBytes:&u32 length:sizeof(u32)];
    u16 = htons(rdlen);
    [rrData appendBytes:&u16 length:sizeof(u16)];
    [rrData appendBytes:rdata length:rdlen];

    dns_resource_record_t* rr = dns_parse_resource_record(rrData.bytes, rrData.length);
    if (rr == NULL) {
        [self fail:[NSError errorWithDomain:DNSQueryErrorDomain code:DNSQueryBadResponse userInfo:nil]];
        return;
    }

    switch (rrtype) {
        case kDNSServiceType_MX: {
            NSString* name = [NSString stringWithUTF8String:rr->data.MX->name];
            if (name == nil) {
                [self fail:[NSError errorWithDomain:DNSQueryErrorDomain code:DNSQueryBadResponse userInfo:nil]];
                return;
            }

            uint16_t preference = rr->data.MX->preference;

            qr.name = name;
            qr.preference = preference;
            break;
        }
    }

    dns_free_resource_record(rr);
}


static void queryRecordCallback(DNSServiceRef serviceRef, DNSServiceFlags flags, uint32_t interfaceIndex,
                                DNSServiceErrorType errorCode, const char *fullname,
                                uint16_t rrtype, uint16_t rrclass,
                                uint16_t rdlen, const void *rdata,
                                uint32_t ttl, void *context) {
    DNSQuery* myself = (__bridge DNSQuery*)context;
    assert([myself isKindOfClass:[DNSQuery class]]);

    if (errorCode != kDNSServiceErr_NoError) {
        [myself stopAndFailWithServiceError:errorCode];
        return;
    }

    [myself processRecord:rrtype rdlen:rdlen rdata:rdata ttl:ttl];

    if (!(flags & kDNSServiceFlagsMoreComing))
        [myself stopAndSucceed];
}


static void socketCallback(CFSocketRef s,
                           CFSocketCallBackType type,
                           CFDataRef address,
                           const void * data,
                           void * info)
{
    DNSQuery* myself = (__bridge DNSQuery*)info;
    assert([myself isKindOfClass:[DNSQuery class]]);

    DNSServiceErrorType err = DNSServiceProcessResult(myself->dnsServiceRef);
    if (err != kDNSServiceErr_NoError)
        [myself stopAndFailWithServiceError:err];
}


@end


@implementation DNSQueryResult

@end
