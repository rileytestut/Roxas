//
//  NSUserDefaultsTests.m
//  Roxas
//
//  Created by Riley Testut on 2/23/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "RSTHelperFile.h"

@import XCTest;

// Dummy NSUserDefaults

@interface NSUserDefaults (TestProperties)

// Primitives
@property (assign, nonatomic) BOOL boolProperty;
@property (assign, nonatomic) float floatProperty;
@property (assign, nonatomic) double doubleProperty;
@property (assign, nonatomic) NSInteger integerProperty;

// Objects
@property (copy, nonatomic) NSURL *URLProperty;
@property (strong, nonatomic) id objectProperty;

// Invalid
@property (assign, nonatomic) short shortProperty;

// Custom Accessors
@property (copy, nonatomic, getter=getMyCustomProperty, setter=setMyCustomProperty:) NSString *customAccessorsProperty;

@property (copy, nonatomic) NSString *nonDynamicProperty;

@end

@implementation NSUserDefaults (TestProperties)

@dynamic boolProperty;
@dynamic floatProperty;
@dynamic doubleProperty;
@dynamic integerProperty;
@dynamic URLProperty;
@dynamic objectProperty;
@dynamic shortProperty;
@dynamic customAccessorsProperty;

- (void)setNonDynamicProperty:(NSString *)nonDynamicProperty
{
}

- (NSString *)nonDynamicProperty
{
    return nil;
}

@end



@interface RSTUserDefaults : NSUserDefaults

// Non-Dynamic Property
@property (copy, nonatomic) NSString *subclassProperty;

@end

@implementation RSTUserDefaults

@synthesize subclassProperty;

@end




@interface NSUserDefaultsTests : XCTestCase

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation NSUserDefaultsTests

- (void)setUp
{
    [super setUp];
    
    NSString *bundleIdentifier = [[NSBundle bundleForClass:self.class] bundleIdentifier];
    self.userDefaults = [[NSUserDefaults alloc] initWithSuiteName:bundleIdentifier];
}

- (void)tearDown
{
    [super tearDown];
    
    NSString *bundleIdentifier = [[NSBundle bundleForClass:self.class] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:bundleIdentifier];
}

- (void)testBOOLs
{
    XCTAssertEqual(NO, self.userDefaults.boolProperty);
    
    self.userDefaults.boolProperty = YES;
    XCTAssertEqual(YES, self.userDefaults.boolProperty);
    
    self.userDefaults.boolProperty = NO;
    XCTAssertEqual(NO, self.userDefaults.boolProperty);
}

- (void)testFloats
{
    XCTAssertEqual(0.0, self.userDefaults.floatProperty);
    
    self.userDefaults.floatProperty = 2.1;
    XCTAssertTrue(CGFloatEqualToFloat(2.1, self.userDefaults.floatProperty));
    
    self.userDefaults.floatProperty = -1.2;
    XCTAssertTrue(CGFloatEqualToFloat(-1.2, self.userDefaults.floatProperty));
    
    self.userDefaults.floatProperty = 0.0;
    XCTAssertTrue(CGFloatEqualToFloat(0.0, self.userDefaults.floatProperty));
}

- (void)testDoubles
{
    XCTAssertEqual(0.0, self.userDefaults.doubleProperty);
    
    self.userDefaults.doubleProperty = 3.6;
    XCTAssertTrue(CGFloatEqualToFloat(3.6, self.userDefaults.doubleProperty));
    
    self.userDefaults.doubleProperty = -4.8;
    XCTAssertTrue(CGFloatEqualToFloat(-4.8, self.userDefaults.doubleProperty));
    
    self.userDefaults.doubleProperty = 0.0;
    XCTAssertTrue(CGFloatEqualToFloat(0.0, self.userDefaults.doubleProperty));
}

- (void)testIntegers
{
    XCTAssertEqual(0, self.userDefaults.boolProperty);
    
    self.userDefaults.integerProperty = 1;
    XCTAssertEqual(1, self.userDefaults.integerProperty);
    
    self.userDefaults.integerProperty = -3;
    XCTAssertEqual(-3, self.userDefaults.integerProperty);
    
    self.userDefaults.integerProperty = 0;
    XCTAssertEqual(0, self.userDefaults.integerProperty);
}

- (void)testURLs
{
    XCTAssertNil(self.userDefaults.URLProperty);
    
    NSURL *URL = [NSURL URLWithString:@"http://rileytestut.com"];
    self.userDefaults.URLProperty = URL;
    XCTAssertEqualObjects(URL, self.userDefaults.URLProperty);
    
    URL = [NSURL URLWithString:@""];
    self.userDefaults.URLProperty = URL;
    XCTAssertEqualObjects(URL, self.userDefaults.URLProperty);
    
    self.userDefaults.URLProperty = nil;
    XCTAssertNil(self.userDefaults.URLProperty);
}

- (void)testObjects
{
    XCTAssertNil(self.userDefaults.objectProperty);
    
    self.userDefaults.objectProperty = @"Roxas";
    XCTAssertEqualObjects(@"Roxas", self.userDefaults.objectProperty);
    
    self.userDefaults.objectProperty = @1;
    XCTAssertEqualObjects(@1, self.userDefaults.objectProperty);
    
    self.userDefaults.objectProperty = @{@"Roxas": @1};
    XCTAssertEqualObjects(@{@"Roxas": @1}, self.userDefaults.objectProperty);
    
    // Unfortunately, trying to test this just results in the test deadlocking :/
    // XCTAssertThrows(self.userDefaults.objectProperty = @{@"operation": [NSOperation new]});
    
    self.userDefaults.objectProperty = [@"Roxas" dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects([@"Roxas" dataUsingEncoding:NSUTF8StringEncoding], self.userDefaults.objectProperty);
    
    self.userDefaults.objectProperty = nil;
    XCTAssertNil(self.userDefaults.objectProperty);
}

- (void)testInvalidProperties
{
    XCTAssertThrows(self.userDefaults.shortProperty);
    XCTAssertThrows(self.userDefaults.shortProperty = 1);
}

- (void)testPersistence
{
    self.userDefaults.customAccessorsProperty = @"Roxas";
    XCTAssertEqualObjects(@"Roxas", self.userDefaults.customAccessorsProperty);
    XCTAssertEqualObjects(@"Roxas", self.userDefaults.dictionaryRepresentation[@"customAccessorsProperty"]);
    
    self.userDefaults.nonDynamicProperty = @"Sora";
    XCTAssertNil(self.userDefaults.nonDynamicProperty);
    XCTAssertNil(self.userDefaults.dictionaryRepresentation[@"nonDynamicProperty"]);
}

- (void)testCustomSubclass
{
    NSString *bundleIdentifier = [[NSBundle bundleForClass:self.class] bundleIdentifier];
    RSTUserDefaults *customUserDefaults = [[RSTUserDefaults alloc] initWithSuiteName:bundleIdentifier];
    
    customUserDefaults.subclassProperty = @"Sora";
    XCTAssertEqualObjects(@"Sora", customUserDefaults.subclassProperty);
    XCTAssertNil(customUserDefaults.dictionaryRepresentation[@"subclassProperty"]);
    
    customUserDefaults.objectProperty = @"Riley";
    XCTAssertEqualObjects(@"Riley", customUserDefaults.objectProperty);
    XCTAssertEqualObjects(@"Riley", customUserDefaults.dictionaryRepresentation[@"objectProperty"]);
}

@end