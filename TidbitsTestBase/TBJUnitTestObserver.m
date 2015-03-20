//
//  TBJUnitTestObserver.m
//  Tidbits
//
//  Created by Ewan Mellor on 3/19/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <KissXML/DDXML.h>
#import <Lumberjack/Lumberjack.h>

#import "Enumerate.h"
#import "LogFormatter.h"

#import "LogCollector.h"

#import "TBJUnitTestObserver.h"


@interface TBJUnitTestObserver ()

@property (nonatomic, readonly) NSString * reportDestination;

@property (nonatomic) LogCollector * logCollector;

@property (nonatomic) NSMutableArray * suites;
@property (nonatomic) NSMutableArray * suiteRunInfo;
@property (nonatomic) NSMutableDictionary * suiteFailures;
@property (nonatomic) NSMutableDictionary * suiteLogs;

@end


@implementation TBJUnitTestObserver


-(instancetype)init {
    self = [super init];
    if (self) {
        _reportDestination = getReportDest();
    }
    return self;
}


static NSString * getReportDest() {
    char * dest = getenv("TBJUnitTestObserverReportDestination");
    if (dest == NULL || dest[0] == '\0') {
        NSString * cwd = [[NSFileManager defaultManager] currentDirectoryPath];
        return [NSString stringWithFormat:@"%@/test-report.xml", cwd];
    }
    else {
        return [NSString stringWithUTF8String:dest];
    }
}


-(void)startObserving {
    [super startObserving];

    self.logCollector = [[LogCollector alloc] init];
    self.logCollector.logFormatter = [[LogFormatter alloc] init];
    [DDLog addLogger:self.logCollector withLogLevel:255];

    self.suites = [NSMutableArray array];
    self.suiteRunInfo = [NSMutableArray array];
}


-(void)stopObserving {
    [self writeReport];

    self.suites = nil;
    self.suiteRunInfo = nil;

    [DDLog removeLogger:self.logCollector];
    self.logCollector = nil;

    [super stopObserving];
}


-(void)testSuiteDidStart:(XCTestRun *)testRun {
    self.suiteFailures = [NSMutableDictionary dictionary];
    self.suiteLogs = [NSMutableDictionary dictionary];
}


-(void)testSuiteDidStop:(XCTestRun *)testRun {
    if (self.suiteFailures == nil) {
        // XCTest has nested suites -- the "All tests" suite is outermost, then your project, then the class.
        // We flatten all this, ignoring all the outer ones, because they aren't representable in the JUnit format.
        return;
    }

    [self.suites addObject:testRun];
    [self.suiteRunInfo addObject:@{@"logs": self.suiteLogs,
                                   @"failures": self.suiteFailures}];
    self.suiteFailures = nil;
    self.suiteLogs = nil;
}


-(void)testCaseDidStart:(XCTestRun *)testRun {
    [self.logCollector collect];
}


-(void)testCaseDidStop:(XCTestRun *)testRun {
    NSArray * logs = [self.logCollector collect];
    self.suiteLogs[testRun.test.name] = logs;
}


-(void)testCaseDidFail:(XCTestRun *)testRun withDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber {
    self.suiteFailures[testRun.test.name] = description;
}


-(void)writeReport {
    DDXMLDocument * doc = [[DDXMLDocument alloc] initWithXMLString:@"<testsuites></testsuites>" options:0 error:NULL];
    DDXMLElement * suitesEl = doc.rootElement;

    [Enumerate pairwiseOver:self.suites and:self.suiteRunInfo usingBlock:^(XCTestSuiteRun * suite, NSDictionary * runInfo) {
        [suitesEl addChild:[TBJUnitTestObserver testSuiteRunToXML:suite failures:runInfo[@"failures"] logs:runInfo[@"logs"]]];
    }];

    [doc.XMLData writeToFile:self.reportDestination atomically:NO];

    NSLog(@"Test results written to %@", self.reportDestination);
}


+(DDXMLElement *)testSuiteRunToXML:(XCTestSuiteRun *)suiteRun failures:(NSDictionary *)failures logs:(NSDictionary *)logs {
    DDXMLElement * result = [DDXMLElement elementWithName:@"testsuite"];

    NSArray * attrs = @[[DDXMLNode attributeWithName:@"name"
                                         stringValue:suiteRun.test.name],
                        [DDXMLNode attributeWithName:@"tests"
                                         stringValue:[NSString stringWithFormat:@"%lu", (unsigned long)suiteRun.testCaseCount]],
                        [DDXMLNode attributeWithName:@"errors"
                                         stringValue:[NSString stringWithFormat:@"%lu", (unsigned long)suiteRun.unexpectedExceptionCount]],
                        [DDXMLNode attributeWithName:@"failures"
                                         stringValue:[NSString stringWithFormat:@"%lu", (unsigned long)suiteRun.failureCount]],
                        [DDXMLNode attributeWithName:@"skipped"
                                         stringValue:@"0"],
                        [DDXMLNode attributeWithName:@"time"
                                         stringValue:[NSString stringWithFormat:@"%f", suiteRun.testDuration]]];
    for (DDXMLNode * attr in attrs) {
        [result addAttribute:attr];
    }

    for (XCTestRun * testRun in suiteRun.testRuns) {
        DDXMLElement * testRunEl = [TBJUnitTestObserver testRunToXML:testRun
                                                             failure:failures[testRun.test.name]
                                                                logs:logs[testRun.test.name]];
        [result addChild:testRunEl];
    }

    return result;
}


+(DDXMLElement *)testRunToXML:(XCTestRun *)testRun failure:(NSString *)failure logs:(NSArray *)logs {
    DDXMLElement * result = [DDXMLElement elementWithName:@"testcase"];

    NSArray * attrs = @[[DDXMLNode attributeWithName:@"name"
                                         stringValue:testRun.test.name],
                        [DDXMLNode attributeWithName:@"classname"
                                         stringValue:NSStringFromClass(testRun.test.class)],
                        [DDXMLNode attributeWithName:@"time"
                                         stringValue:[NSString stringWithFormat:@"%f", testRun.testDuration]]];
    for (DDXMLNode * attr in attrs) {
        [result addAttribute:attr];
    }

    if (failure != nil) {
        [result addChild:[DDXMLElement elementWithName:@"failure" stringValue:failure]];
    }

    [result addChild:[DDXMLElement elementWithName:@"system-out" cdata:[logs componentsJoinedByString:@"\n"]]];

    return result;
}


@end
