//
//  NSStringLocalizationTests.m
//  Roxas
//
//  Created by Riley Testut on 1/13/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import "NSString+Localization.h"
#import "RSTSilentAssertionHandler.h"

@import XCTest;

@interface NSStringLocalizationTests : XCTestCase

@end

@implementation NSStringLocalizationTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSystemLocalization
{    
    XCTAssertNoThrow(RSTSystemLocalizedString(@"Done"));
    
    XCTAssertThrows(RSTSystemLocalizedString(@"Riley Testut"));
    
    [RSTSilentAssertionHandler enable];
    XCTAssertEqualObjects(@"Riley Testut", RSTSystemLocalizedString(@"Riley Testut"));
    [RSTSilentAssertionHandler disable];
    
}

@end
