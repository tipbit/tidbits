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
#import "NSDate+ISO8601.h"

#import "LogCollector.h"

#import "TBJUnitTestObserver.h"


@interface TBJUnitTestObserver ()

@property (nonatomic, readonly) NSString * reportDestination;

@property (nonatomic) LogCollector * logCollector;

@property (nonatomic) NSMutableArray * suites;
@property (nonatomic) NSMutableArray * suiteRunInfo;
@property (nonatomic) NSMutableDictionary * suiteFailures;
@property (nonatomic) NSMutableDictionary * suiteFailureLocations;
@property (nonatomic) NSMutableDictionary * suiteLogs;
@property (nonatomic) XCTestRun * topRun;

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
    self.suiteFailureLocations = [NSMutableDictionary dictionary];
    self.suiteLogs = [NSMutableDictionary dictionary];
}


-(void)testSuiteDidStop:(XCTestRun *)testRun {
    if (self.suiteFailures == nil) {
        // XCTest has nested suites -- the "All tests" suite is outermost, then your project, then the class.
        // We flatten all this, ignoring all the outer ones, because they aren't representable in the JUnit format.
        self.topRun = testRun;
        return;
    }

    [self.suites addObject:testRun];
    [self.suiteRunInfo addObject:@{@"logs": self.suiteLogs,
                                   @"failures": self.suiteFailures,
                                   @"failureLocations": self.suiteFailureLocations}];
    self.suiteFailures = nil;
    self.suiteFailureLocations = nil;
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
    self.suiteFailureLocations[testRun.test.name] = [NSString stringWithFormat:@"%@:%lu", filePath, (unsigned long)lineNumber];
}


-(void)writeReport {
    DDXMLDocument * doc = [[DDXMLDocument alloc] initWithXMLString:@"<testsuites></testsuites>" options:0 error:NULL];
    DDXMLElement * suitesEl = doc.rootElement;

    NSArray * attrs = testSuiteRunAttrs(self.topRun);
    for (DDXMLNode * attr in attrs) {
        [suitesEl addAttribute:attr];
    }

    [Enumerate pairwiseOver:self.suites and:self.suiteRunInfo usingBlock:^(XCTestSuiteRun * suite, NSDictionary * runInfo) {
        [suitesEl addChild:[TBJUnitTestObserver testSuiteRunToXML:suite failures:runInfo[@"failures"] failureLocations:runInfo[@"failureLocations"] logs:runInfo[@"logs"]]];
    }];

    [doc.XMLData writeToFile:self.reportDestination atomically:NO];

    NSLog(@"Test results written to %@", self.reportDestination);
}


+(DDXMLElement *)testSuiteRunToXML:(XCTestSuiteRun *)suiteRun failures:(NSDictionary *)failures failureLocations:(NSDictionary *)failureLocations logs:(NSDictionary *)logs {
    DDXMLElement * result = [DDXMLElement elementWithName:@"testsuite"];

    NSArray * attrs = testSuiteRunAttrs(suiteRun);
    for (DDXMLNode * attr in attrs) {
        [result addAttribute:attr];
    }

    for (XCTestRun * testRun in suiteRun.testRuns) {
        DDXMLElement * testRunEl = [TBJUnitTestObserver testRunToXML:testRun
                                                             failure:failures[testRun.test.name]
                                                     failureLocation:failureLocations[testRun.test.name]
                                                                logs:logs[testRun.test.name]];
        [result addChild:testRunEl];
    }

    return result;
}


static NSArray * testSuiteRunAttrs(XCTestRun * run) {
    return @[[DDXMLNode attributeWithName:@"name"
                              stringValue:run.test.name],
             [DDXMLNode attributeWithName:@"tests"
                              stringValue:[NSString stringWithFormat:@"%lu", (unsigned long)run.testCaseCount]],
             [DDXMLNode attributeWithName:@"errors"
                              stringValue:[NSString stringWithFormat:@"%lu", (unsigned long)run.unexpectedExceptionCount]],
             [DDXMLNode attributeWithName:@"failures"
                              stringValue:[NSString stringWithFormat:@"%lu", (unsigned long)run.failureCount]],
             [DDXMLNode attributeWithName:@"time"
                              stringValue:[NSString stringWithFormat:@"%f", run.testDuration]],
             [DDXMLNode attributeWithName:@"timestamp"
                              stringValue:run.startDate.iso8601String]];
}


+(DDXMLElement *)testRunToXML:(XCTestRun *)testRun failure:(NSString *)failure failureLocation:(NSString *)failureLocation logs:(NSArray *)logs {
    DDXMLElement * result = [DDXMLElement elementWithName:@"testcase"];

    NSArray * attrs = @[[DDXMLNode attributeWithName:@"name"
                                         stringValue:testRun.test.name],
                        [DDXMLNode attributeWithName:@"classname"
                                         stringValue:NSStringFromClass(testRun.test.class)],
                        [DDXMLNode attributeWithName:@"time"
                                         stringValue:[NSString stringWithFormat:@"%f", testRun.testDuration]],
                        [DDXMLNode attributeWithName:@"timestamp"
                                         stringValue:testRun.startDate.iso8601String]];
    for (DDXMLNode * attr in attrs) {
        [result addAttribute:attr];
    }

    DDXMLElement * failureEl = [TBJUnitTestObserver failureToXML:failure location:failureLocation];
    if (failureEl != nil) {
        [result addChild:failureEl];
    }

    if (logs.count > 0) {
        [result addChild:[DDXMLElement elementWithName:@"system-out" cdata:[logs componentsJoinedByString:@"\n"]]];
    }

    return result;
}


+(DDXMLElement *)failureToXML:(NSString *)msg location:(NSString *)location {
    if (msg == nil && location == nil) {
        return nil;
    }
    DDXMLElement * result = [DDXMLElement elementWithName:@"failure"];
    [result addAttribute:[DDXMLNode attributeWithName:@"type" stringValue:@"Failure"]];
    if (msg != nil) {
        [result addAttribute:[DDXMLNode attributeWithName:@"message" stringValue:msg]];
    }
    if (location != nil) {
        [result setStringValue:location];
    }
    return result;
}


@end
