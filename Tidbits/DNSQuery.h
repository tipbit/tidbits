//
//  DNSQuery.h
//  Tidbits
//
//  Created by Ewan Mellor on 9/29/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <dns_sd.h>
#import <Foundation/Foundation.h>


extern NSString* const DNSQueryErrorDomain;
extern NSString* const kDNSServiceErrorType;

typedef enum {
    DNSQueryBadArgument = 1,
    DNSQueryServiceFailure = 2,
    DNSQueryBadResponse = 3,
} DNSQueryError;


@protocol DNSQueryDelegate;


@interface DNSQuery : NSObject

/**
 * @param rrtype kDNSServiceType_*.
 */
-(instancetype)init:(NSString*)fullname_ rrtype:(uint16_t)rrtype_ delegate:(id<DNSQueryDelegate>)delegate_;

/**
 * Starts the DNS query, and adds the socket to the current run loop.
 * The DNSQueryDelegate will be called on the main thread when results are received or if an error occurs.
 */
-(void)start;

/**
 * Stops the DNS query.
 */
-(void)stop;

@end


@protocol DNSQueryDelegate <NSObject>

/**
 * @param result A DNSQueryResult array.
 */
-(void)dnsQuery:(DNSQuery*)dnsQuery succeededWithResult:(NSArray*)result;

/**
 * See DNSQueryError, DNSQueryErrorDomain.
 */
-(void)dnsQuery:(DNSQuery*)dnsQuery failedWithError:(NSError*)error;

@end


/**
 * c.f. DNSServiceQueryRecordReply in dns_sd.h.
 */
@interface DNSQueryResult : NSObject


/**
 * The resource record's full domain name.
 */
@property (nonatomic, strong) NSString* fullname;

/**
 * rrtype:          The resource record's type (e.g. kDNSServiceType_PTR, kDNSServiceType_SRV, etc)
 */
@property (nonatomic, assign) uint16_t rrtype;

/**
 * ttl:             If the client wishes to cache the result for performance reasons,
 *                  the TTL indicates how long the client may legitimately hold onto
 *                  this result, in seconds. After the TTL expires, the client should
 *                  consider the result no longer valid, and if it requires this data
 *                  again, it should be re-fetched with a new query.
 */
@property (nonatomic, assign) uint32_t ttl;


/**
 * The record's name field.  Seen on MX records.
 */
@property (nonatomic, strong) NSString* name;


/**
 * The record's preference field.  Seen on MX records.
 */
@property (nonatomic, assign) uint16_t preference;


@end
