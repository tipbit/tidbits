//
//  PunycodeTests.m
//  PunycodeTests
//
//  Created by Nate Weaver on 3/2/12.
//  Copyright (c) 2012 Derailer. All rights reserved.
//

#import "NSStringPunycodeAdditions.h"

#import "TBTestCaseBase.h"


@interface PunycodeTests : TBTestCaseBase

@end


@implementation PunycodeTests


-(void)testPunycodeEncoding {
	NSDictionary *dict = @{@"bücher": @"bcher-kva",
						  @"президент": @"d1abbgf6aiiy",
						  @"例え": @"r8jz45g"};
	
	[dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		XCTAssert([[key punycodeEncodedString] isEqualToString:obj], @"%@ should encode to %@", key, obj);
	}];
}


-(void)testPunycodeDecoding {
	NSDictionary *dict = @{@"bcher-kva": @"bücher",
						  @"d1abbgf6aiiy": @"президент",
						  @"r8jz45g": @"例え"};
	
	[dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		XCTAssert([[key punycodeDecodedString] isEqualToString:obj], @"%@ should decode to %@", key, obj);
	}];
}


@end
