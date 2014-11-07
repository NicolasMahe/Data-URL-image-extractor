//
//  Data_URL_image_extractorTests.m
//  Data URL image extractorTests
//
//  Created by Nicolas Mahe on 06/11/14.
//  Copyright (c) 2014 Nicolas Mahe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "Extractor.h"

@interface Data_URL_image_extractorTests : XCTestCase

@end

@implementation Data_URL_image_extractorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSimpleQuote {
    NSString* testString = @"<img width='11' height='14' src='data:image/gif;base64,R0lGODlhCwAOAMQfAP////7+/vj4+Hh4eHd3d/v7+/Dw8HV1dfLy8ubm5vX19e3t7fr6+nl5edra2nZ2dnx8fMHBwYODg/b29np6eujo6JGRkeHh4eTk5LCwsN3d3dfX13Jycp2dnevr6////yH5BAEAAB8ALAAAAAALAA4AAAVq4NFw1DNAX/o9imAsBtKpxKRd1+YEWUoIiUoiEWEAApIDMLGoRCyWiKThenkwDgeGMiggDLEXQkDoThCKNLpQDgjeAsY7MHgECgx8YR8oHwNHfwADBACGh4EDA4iGAYAEBAcQIg0DkgcEIQA7' alt='File Icon'>";
    NSString* url = @"http://www.example.com/images/";
    NSString* resultStrong = @"<img width='11' height='14' src='http://www.example.com/images/ca9c24a1e75b36ba81abf90d13fb5212.gif' alt='File Icon'>";
    
    Extractor* extractor = [[Extractor alloc] init];
    NSString* result = [extractor replaceImageInString:testString withUrl:url saveInFolder:nil];
    
    XCTAssert([result isEqualToString:resultStrong], @"testSimpleQuote pass");
}

- (void)testDoubleQuote {
    NSString* testString = @"<img width=\"11\" height=\"14\" src=\"data:image/gif;base64,R0lGODlhCwAOAMQfAP////7+/vj4+Hh4eHd3d/v7+/Dw8HV1dfLy8ubm5vX19e3t7fr6+nl5edra2nZ2dnx8fMHBwYODg/b29np6eujo6JGRkeHh4eTk5LCwsN3d3dfX13Jycp2dnevr6////yH5BAEAAB8ALAAAAAALAA4AAAVq4NFw1DNAX/o9imAsBtKpxKRd1+YEWUoIiUoiEWEAApIDMLGoRCyWiKThenkwDgeGMiggDLEXQkDoThCKNLpQDgjeAsY7MHgECgx8YR8oHwNHfwADBACGh4EDA4iGAYAEBAcQIg0DkgcEIQA7\" alt=\"File Icon\">";
    NSString* url = @"http://www.example.com/images/";
    NSString* resultStrong = @"<img width=\"11\" height=\"14\" src=\"http://www.example.com/images/ca9c24a1e75b36ba81abf90d13fb5212.gif\" alt=\"File Icon\">";
    
    Extractor* extractor = [[Extractor alloc] init];
    NSString* result = [extractor replaceImageInString:testString withUrl:url saveInFolder:nil];
    
    XCTAssert([result isEqualToString:resultStrong], @"testDoubleQuote pass");
}

-(void)testSimplePerformanceTwo
{
    NSError *error;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"testBigDataInput" ofType:@"txt"];
    NSString *testString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSString* url = @"http://www.example.com/images/";
    
    
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    
    Extractor* extractor = [[Extractor alloc] init];
    
    [self measureBlock:^{
        [extractor replaceImageInString:testString withUrl:url saveInFolder:nil];
    }];
}

@end
