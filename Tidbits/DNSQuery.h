//
//  DNSQuery.h
//  Tidbits
//
//  Created by Ewan Mellor on 9/29/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <nameser.h>


extern NSString* const DNSQueryErrorDomain;
extern NSString* const kDNSQueryServiceFailureCode;

typedef enum {
    DNSQueryBadArgument = 1,
    DNSQueryServiceFailure = 2,
    DNSQueryBadResponse = 3,
    DNSQueryNoSuchDomain = 4,
} DNSQueryError;


@protocol DNSQueryDelegate;


@interface DNSQuery : NSObject

/**
 * @param rrtype ns_t_*.
 */
-(instancetype)init:(NSString*)fullname_ rrtype:(ns_type)rrtype_ delegate:(id<DNSQueryDelegate>)delegate_;

/**
 * Starts the DNS query on a background thread.
 * The DNSQueryDelegate will be called on the main thread when results are received or if an error occurs.
 */
-(void)start;

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
 * rrtype:          The resource record's type (e.g. ns_t_mx, etc)
 */
@property (nonatomic, assign) ns_type rrtype;

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
