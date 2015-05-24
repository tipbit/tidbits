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


-(void)testUtiConformsTo {
    XCTAssert(utiConformsTo(@"public.png", @"public.png"));
    XCTAssertFalse(utiConformsTo(@"public.png", @"public.jpeg"));
    XCTAssert(utiConformsTo(@"public.png", @"public.image"));
    XCTAssertFalse(utiConformsTo(@"public.image", @"public.png"));
    XCTAssertFalse(utiConformsTo(@"", @"public.data"));
    XCTAssertFalse(utiConformsTo(@" ", @"public.data"));
    XCTAssertFalse(utiConformsTo(nil, nil));
}


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


-(void)testUtiFilenameToType {
    XCTAssertEqualStrings(utiFilenameToType(@"file.jpeg"), @"public.jpeg");
    XCTAssertEqualStrings(utiFilenameToType(@"file.pdf"), @"com.adobe.pdf");
    XCTAssertNil(utiFilenameToType(nil));
    XCTAssertNil(utiFilenameToType(@""));
    XCTAssertNil(utiFilenameToType(@" "));
    XCTAssertNil(utiFilenameToType(@"file.eml"));
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


-(void)testUtiMIMEToType {
    XCTAssertEqualStrings(utiMIMEToType(@"image/jpeg"), @"public.jpeg");
    XCTAssertEqualStrings(utiMIMEToType(@"application/pdf"), @"com.adobe.pdf");
    XCTAssertNil(utiMIMEToType(nil));
    XCTAssertNil(utiMIMEToType(@" "));
    XCTAssertNil(utiMIMEToType(@"image"));
}


-(void)testUtiHumanReadableDescriptionJPEG {
    NSString * input = @"public.jpeg";
    NSString * result = utiHumanReadableDescription(input);
    XCTAssertEqualStrings(result, @"JPEG image");
}


-(void)testUtiIsImageYes {
    NSArray * inputs = @[@"foo.png", @"foo.jpeg", @"foo.jpg", @"foo.gif"];
    for (NSString * input in inputs) {
        XCTAssert(utiIsImage(utiFilenameToType(input)));
    }
}


-(void)testUtiIsImageNo {
    NSArray * inputs = @[@"foo.mp3", @"foo.pdf", @"foo", @"", @" ", @"\n"];
    for (NSString * input in inputs) {
        XCTAssertFalse(utiIsImage(utiFilenameToType(input)));
    }
}


-(void)testUtiIsImageNil {
    XCTAssertFalse(utiIsImage(nil));
    XCTAssertFalse(utiIsImage(@""));
    XCTAssertFalse(utiIsImage(@" "));
    XCTAssertFalse(utiIsImage(@"\n"));
}


@end
