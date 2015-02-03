//
//  NSURL+MailtoTests.m
//  Tidbits
//
//  Created by Ewan Mellor on 2/2/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "NSURL+Mailto.h"

#import "TBTestCaseBase.h"


@interface NSURL_MailtoTests : TBTestCaseBase

@end


@implementation NSURL_MailtoTests



-(void)testParseMailtoEmpty {
    NSURL * input = [NSURL URLWithString:@"mailto:"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertNil(to);
    XCTAssertNil(subject);
    XCTAssertNil(body);
}


-(void)testParseMailtoMultipleTo {
    NSURL * input = [NSURL URLWithString:@"mailto:example1@example.com,example2@example.com"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects((@[@"example1@example.com", @"example2@example.com"]), to);
    XCTAssertNil(subject);
    XCTAssertNil(body);
}


-(void)testParseMailtoRFC6068BillPlusIETF {
    NSURL * input = [NSURL URLWithString:@"mailto:bill+ietf@example.org"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"bill+ietf@example.org"], to);
    XCTAssertNil(subject);
    XCTAssertNil(body);
}


-(void)testParseMailtoRFC6068Chris {
    NSURL * input = [NSURL URLWithString:@"mailto:chris@example.com"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"chris@example.com"], to);
    XCTAssertNil(subject);
    XCTAssertNil(body);
}


-(void)testParseMailtoRFC6068Subject {
    NSURL * input = [NSURL URLWithString:@"mailto:infobot@example.com?subject=current-issue"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"infobot@example.com"], to);
    XCTAssertEqualStrings(subject, @"current-issue");
    XCTAssertNil(body);
}


-(void)testParseMailtoRFC6068Body {
    NSURL * input = [NSURL URLWithString:@"mailto:infobot@example.com?body=send%20current-issue"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"infobot@example.com"], to);
    XCTAssertNil(subject);
    XCTAssertEqualStrings(@"send current-issue", body);
}


-(void)testParseMailtoRFC6068Body2 {
    NSURL * input = [NSURL URLWithString:@"mailto:infobot@example.com?body=send%20current-issue%0D%0Asend%20index"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"infobot@example.com"], to);
    XCTAssertNil(subject);
    XCTAssertEqualStrings(@"send current-issue\r\nsend index", body);
}


-(void)testParseMailtoRFC6068InReplyTo {
    NSURL * input = [NSURL URLWithString:@"mailto:list@example.org?In-Reply-To=%3C3469A91.D10AF4C@example.com%3E"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"list@example.org"], to);
    XCTAssertNil(subject);
    XCTAssertNil(body);
}


-(void)testParseMailtoRFC6068Subscribe {
    NSURL * input = [NSURL URLWithString:@"mailto:majordomo@example.com?body=subscribe%20bamboo-l"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"majordomo@example.com"], to);
    XCTAssertNil(subject);
    XCTAssertEqualStrings(@"subscribe bamboo-l", body);
}


-(void)testParseMailtoRFC6068Cc {
    NSURL * input = [NSURL URLWithString:@"mailto:joe@example.com?cc=bob@example.com&body=hello"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"joe@example.com"], to);
    XCTAssertNil(subject);
    XCTAssertEqualStrings(@"hello", body);
}


/**
 * The second question mark is illegal according to the RFC.  We muddle through and parse everything up to that.
 */
-(void)testParseMailtoRFC6068Wrong {
    NSURL * input = [NSURL URLWithString:@"mailto:joe@example.com?cc=bob@example.com?body=hello"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"joe@example.com"], to);
    XCTAssertNil(subject);
    XCTAssertNil(body);
}


-(void)testParseMailtoRFC6068EncodedAddr {
    NSURL * input = [NSURL URLWithString:@"mailto:gorby%25kremvax@example.com"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"gorby%kremvax@example.com"], to);
    XCTAssertNil(subject);
    XCTAssertNil(body);
}


-(void)testParseMailtoRFC6068Unlikely {
    NSURL * input = [NSURL URLWithString:@"mailto:unlikely%3Faddress@example.com?blat=foop"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"unlikely?address@example.com"], to);
    XCTAssertNil(subject);
    XCTAssertNil(body);
}


/**
 * The RFC shows an HTML-based example, but we don't care about that, so our ampersand is not escaped as &amp;.
 */
-(void)testParseMailtoRFC6068Ampersand {
    NSURL * input = [NSURL URLWithString:@"mailto:joe@an.example?cc=bob@an.example&body=hello"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"joe@an.example"], to);
    XCTAssertNil(subject);
    XCTAssertEqualStrings(body, @"hello");
}


-(void)testParseMailtoRFC6068AmpersandInAddr {
    NSURL * input = [NSURL URLWithString:@"mailto:Mike%26family@example.org"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"Mike&family@example.org"], to);
    XCTAssertNil(subject);
    XCTAssertNil(body);
}


-(void)testParseMailtoRFC6068DoubleQuotes {
    NSURL * input = [NSURL URLWithString:@"mailto:%22not%40me%22@example.org"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"\"not@me\"@example.org"], to);
    XCTAssertNil(subject);
    XCTAssertNil(body);
}


-(void)testParseMailtoRFC6068DoubleQuotesAndBackslashes {
    NSURL * input = [NSURL URLWithString:@"mailto:%22oh%5C%5Cno%22@example.org"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"\"oh\\\\no\"@example.org"], to);
    XCTAssertNil(subject);
    XCTAssertNil(body);
}


-(void)testParseMailtoRFC6068Ugly {
    NSURL * input = [NSURL URLWithString:@"mailto:%22%5C%5C%5C%22it's%5C%20ugly%5C%5C%5C%22%22@example.org"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"\"\\\\\\\"it's\\ ugly\\\\\\\"\"@example.org"], to);
    XCTAssertNil(subject);
    XCTAssertNil(body);
}


-(void)testParseMailtoRFC6068FrenchUTF8 {
    NSURL * input = [NSURL URLWithString:@"mailto:user@example.org?subject=caf%C3%A9"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"user@example.org"], to);
    XCTAssertEqualStrings(@"café", subject);
    XCTAssertNil(body);
}


/**
 * Note that the RFC 2047 decoding is not done.
 */
-(void)testParseMailtoRFC6068FrenchEncodedWordUTF8 {
    NSURL * input = [NSURL URLWithString:@"mailto:user@example.org?subject=%3D%3Futf-8%3FQ%3Fcaf%3DC3%3DA9%3F%3D"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"user@example.org"], to);
    XCTAssertEqualStrings(@"=?utf-8?Q?caf=C3=A9?=", subject);
    XCTAssertNil(body);
}


/**
 * Note that the RFC 2047 decoding is not done.
 */
-(void)testParseMailtoRFC6068FrenchEncodedWordLatin1 {
    NSURL * input = [NSURL URLWithString:@"mailto:user@example.org?subject=%3D%3Fiso-8859-1%3FQ%3Fcaf%3DE9%3F%3D"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"user@example.org"], to);
    XCTAssertEqualStrings(@"=?iso-8859-1?Q?caf=E9?=", subject);
    XCTAssertNil(body);
}


-(void)testParseMailtoRFC6068FrenchUTF8WithBody {
    NSURL * input = [NSURL URLWithString:@"mailto:user@example.org?subject=caf%C3%A9&body=caf%C3%A9"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"user@example.org"], to);
    XCTAssertEqualStrings(@"café", subject);
    XCTAssertEqualStrings(@"café", body);
}


-(void)testParseMailtoRFC6068Japanese {
    NSURL * input = [NSURL URLWithString:@"mailto:user@%E7%B4%8D%E8%B1%86.example.org?subject=Test&body=NATTO"];
    NSArray * to;
    NSString * subject;
    NSString * body;
    [input parseMailtoReturningTo:&to subject:&subject body:&body];
    XCTAssertEqualObjects(@[@"user@xn--99zt52a.example.org"], to);
    XCTAssertEqualStrings(@"Test", subject);
    XCTAssertEqualStrings(@"NATTO", body);
}


@end
