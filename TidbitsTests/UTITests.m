//
//  UTITests.m
//  Tidbits
//
//  Created by Ewan Mellor on 11/15/14.
//  Copyright (c) 2014 Tipbit, Inc. All rights reserved.
//

#import "UTI.h"

#import "TBTestCaseBase.h"


@interface UTITests : TBTestCaseBase

@end


@implementation UTITests


-(void)testUtiFilenameToMIMEEML {
    NSString * input = @"file.eml";
    NSString * result = utiFilenameToMIME(input);
    XCTAssertEqualStrings(result, @"message/rfc822");
}


-(void)testUtiFilenameToMIMEJPEG {
    NSString * input = @"file.jpeg";
    NSString * result = utiFilenameToMIME(input);
    XCTAssertEqualStrings(result, @"image/jpeg");
}


-(void)testUtiMIMEToExtensionEML {
    NSString * input = @"message/rfc822";
    NSString * result = utiMIMEToExtension(input);
    XCTAssertEqualStrings(result, @"eml");
}


-(void)testUtiMIMEToExtensionJPEG {
    NSString * input = @"image/jpeg";
    NSString * result = utiMIMEToExtension(input);
    XCTAssertEqualStrings(result, @"jpeg");
}


-(void)testUtiHumanReadableDescriptionJPEG {
    NSString * input = @"public.jpeg";
    NSString * result = utiHumanReadableDescription(input);
    XCTAssertEqualStrings(result, @"JPEG image");
}


@end
