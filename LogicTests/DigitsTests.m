//
//  DigitsTests.m
//  AllYourBase
//
//  Created by Tiago Henriques on 4/4/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "DigitsTests.h"


@implementation DigitsTests

- (void)setUp
{
    [super setUp];
    
    NSLog(@"%@ setUp", self.name);
}

- (void)tearDown
{
    NSLog(@"%@ tearDown", self.name);
    
    [super tearDown];
}

- (void)testInit {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);

    actual = digits.signedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithStringNil {
    Digits *digits = [[[Digits alloc] initWithString:nil] retain];
    STAssertNil(digits, @"Should not be able to create Digits instance");
}

- (void)testInitWithEmptyStringBase1 {
    Digits *digits = [[[Digits alloc] initWithString:@"" base:1] retain];
    STAssertNil(digits, @"Should not be able to create Digits instance");
}

- (void)testInitWithSpace123SpaceSpace {
    
    Digits *digits = [[[Digits alloc] initWithString:@"  123 "] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 123, @"'%qi' should be equal to '%d'", digits.integerValue, 123);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithMinus12 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"-12"] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == -12, @"'%qi' should be equal to '%d'", digits.integerValue, -12);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWith1234567890 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"1234567890"] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 1234567890, @"'%qi' should be equal to '%d'", digits.integerValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWith1234567890abc {
    
    Digits *digits = [[[Digits alloc] initWithString:@"1234567890abc"] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 1234567890, @"'%qi' should be equal to '%d'", digits.integerValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithSpaceMinus123abc456SpaceSpace {
    
    Digits *digits = [[[Digits alloc] initWithString:@"  -123abc456 "] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == -123, @"'%qi' should be equal to '%d'", digits.integerValue, -123);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test0 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test00 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
    [digits pushDigit:@"0"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test1 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 1, @"'%qi' should be equal to '%d'", digits.integerValue, 1);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPoint {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"."];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPointPoint {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"."];
    [digits pushDigit:@"."];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPoint3 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"."];
    [digits pushDigit:@"3"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0.3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0.3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test0Point {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
    [digits pushDigit:@"."];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegative {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegativePoint {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    [digits pushDigit:@"."];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPointNegative {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"."];
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test1Point {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    [digits pushDigit:@"."];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 1, @"'%qi' should be equal to '%d'", digits.integerValue, 1);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"1.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test0Point1 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
    [digits pushDigit:@"."];
    [digits pushDigit:@"1"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0.1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0.1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test1Point2 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    [digits pushDigit:@"."];
    [digits pushDigit:@"2"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 1, @"'%qi' should be equal to '%d'", digits.integerValue, 1);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1.2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1.2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"1.2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test1And2And3 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];    
    [digits pushDigit:@"2"];    
    [digits pushDigit:@"3"];    

    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 123, @"'%qi' should be equal to '%d'", digits.integerValue, 123);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test123 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"123"];    
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.signedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);

    actual = digits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test1AndA {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];    
    [digits pushDigit:@"A"];    
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 1, @"'%qi' should be equal to '%d'", digits.integerValue, 1);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPop {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    NSString *actual, *expected;
    
    actual = [digits popDigit];
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.unsignedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.signedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test0Pop {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
        
    NSString *actual, *expected;
    
    actual = [digits popDigit], expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);

    actual = digits.unsignedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.signedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test1Pop {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    
    NSString *actual, *expected;
    
    actual = [digits popDigit], expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
        
    actual = digits.unsignedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.signedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);

    actual = digits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegatePop {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    
    [digits negate];

    STAssertTrue(digits.startsWithMinus == YES, @"");

    NSString *actual, *expected;
    
    actual = [digits popDigit], expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    STAssertTrue(digits.startsWithMinus == YES, @"");
    
    actual = digits.unsignedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.signedDigits, expected = @"-";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegatePopPop {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    
    NSString *actual, *expected;
    
    [digits popDigit];
    actual = [digits popDigit], expected = @"-";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    STAssertTrue(digits.startsWithMinus == NO, @"");
    
    actual = digits.unsignedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.signedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test1And2And3Pop {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];    
    [digits pushDigit:@"2"];    
    [digits pushDigit:@"3"];

    NSString *actual, *expected;
    
    actual = [digits popDigit], expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
        
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 12, @"'%qi' should be equal to '%d'", digits.integerValue, 12);
    
    actual = digits.unsignedDigits, expected = @"12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithLongLongNegative46656 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:-46656] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == -46656, @"'%qi' should be equal to '%d'", digits.integerValue, -46656);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"46656";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-46656";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithLongLong0 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:0] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithLongLong1234567890 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:1234567890] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 1234567890, @"'%qi' should be equal to '%d'", digits.integerValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithLongLongNegative1234567890 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:-1234567890] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == -1234567890, @"'%qi' should be equal to '%d'", digits.integerValue, -1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithLongLong1234567890Base2 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:1234567890 base:2] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 2, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 1234567890, @"'%qi' should be equal to '%d'", digits.integerValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1001001100101100000001011010010";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1001001100101100000001011010010";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithLongLong0x7fffffff { // maximum int value on 32 bits architectures like the iPhone
    
    Digits *digits = [[[Digits alloc] initWithLongLong:0x7fffffff] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0x7fffffff, @"'%x' should be equal to '%x'", digits.integerValue, 0x7fffffff);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483647";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"2147483647";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithLongLong0x7fffffffLL { // maximum int value on 32 bits architectures like the iPhone
    
    Digits *digits = [[[Digits alloc] initWithLongLong:0x7fffffffLL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0x7fffffffLL, @"'%x' should be equal to '%x'", digits.integerValue, 0x7fffffffLL);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483647";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"2147483647";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithLongLong0x80000000 { // 0x7fffffff + 1 overflows to -0x80000000 instead of -0x80000000
    
    Digits *digits = [[[Digits alloc] initWithLongLong:0x80000000] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0x80000000, @"'%qx' should be equal to '%x'", digits.integerValue, 0x80000000);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithLongLong0x80000000LL { // 0x7fffffff + 1 overflows to -0x80000000 instead of -0x80000000
    
    Digits *digits = [[[Digits alloc] initWithLongLong:0x80000000LL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0x80000000LL, @"'%qx' should be equal to '%qx'", digits.integerValue, 0x80000000LL);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithLongLongNegative0x80000000 { // minimum int value on 32 bits architectures like the iPhone
    
    Digits *digits = [[[Digits alloc] initWithLongLong:-0x80000000] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == -0x80000000, @"'%x' should be equal to '%x'", digits.integerValue, -0x80000000);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithLongLongNegative0x80000000LL { // minimum int value on 32 bits architectures like the iPhone
    
    Digits *digits = [[[Digits alloc] initWithLongLong:-0x80000000LL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == -0x80000000LL, @"'%x' should be equal to '%x'", digits.integerValue, -0x80000000LL);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithLongLongNegative0x800000001 { // -0x80000000 - 1 overflows to -1 instead of -0x80000001
    
    Digits *digits = [[[Digits alloc] initWithLongLong:-0x800000001] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == -0x80000001, @"'%x' should be equal to '%x'", digits.integerValue, -0x80000001);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483649";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-2147483649";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithLongLongNegative0x800000001LL { // -0x80000000 - 1 overflows to -1 instead of -0x80000001
    
    Digits *digits = [[[Digits alloc] initWithLongLong:-0x800000001LL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == -0x80000001LL, @"'%x' should be equal to '%x'", digits.integerValue, -0x80000001LL);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483649";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-2147483649";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString1001001100101100000001011010010Base2 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"1001001100101100000001011010010" base:2] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 2, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 1234567890, @"'%qi' should be equal to '%d'", digits.integerValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1001001100101100000001011010010";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1001001100101100000001011010010";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithLongLong1234567890Base8 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:1234567890 base:8] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 8, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 1234567890, @"'%qi' should be equal to '%d'", digits.integerValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"11145401322";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"11145401322";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWith1234567890Base8 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"11145401322" base:8] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 8, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 1234567890, @"'%qi' should be equal to '%d'", digits.integerValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"11145401322";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"11145401322";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithLongLong1234567890Base16 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:1234567890 base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 16, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 1234567890, @"'%qi' should be equal to '%d'", digits.integerValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWith499602D2Base16 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"499602D2" base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 16, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 1234567890, @"'%qi' should be equal to '%d'", digits.integerValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithLongLongNegative1234567890Base16 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:-1234567890 base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 16, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == -1234567890, @"'%qi' should be equal to '%d'", digits.integerValue, -1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithNegative499602D2Base16 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"-499602D2" base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 16, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == -1234567890, @"'%qi' should be equal to '%d'", digits.integerValue, -1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test0Plus1PlusMinus2 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"-2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first plus:second withError:NULL] plus:third withError:NULL];
    int actual = result.integerValue, expected = -1;
    STAssertTrue(actual == expected, @"'%qi' should be equal to '%d'", actual, expected);
}

- (void)test0Minus1Minus2 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first minus:second withError:NULL] minus:third withError:NULL];
    int actual = result.integerValue, expected = -3;
    STAssertTrue(actual == expected, @"'%qi' should be equal to '%d'", actual, expected);
}

- (void)test0Times1Times2 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first times:second withError:NULL] times:third withError:NULL];
    int actual = result.integerValue, expected = 0;
    STAssertTrue(actual == expected, @"'%qi' should be equal to '%d'", actual, expected);
}

- (void)test1Times2TimesMinus3 {
    Digits *first = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"-3"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *result = [[first times:second withError:NULL] times:third withError:NULL];
    int actual = result.integerValue, expected = -6;
    STAssertTrue(actual == expected, @"'%qi' should be equal to '%d'", actual, expected);
}

- (void)test1TimesNil {
    Digits *first = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = nil;
    Digits *result = [first times:second withError:NULL];
    STAssertNil(result, @"'%@' should be nil", result);
}

- (void)test1DivideNil {
    Digits *first = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = nil;
    Digits *result = [first divide:second withError:NULL];
    STAssertNil(result, @"'%@' should be nil", result);
}

- (void)test1Divide0 {
    Digits *first = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");

    NSError *error = nil;
    Digits *result = [first divide:second withError:&error];

    STAssertNil(result, @"'%@' should be nil", result);
    STAssertNotNil(error, @"'%@' should not be nil", result);
    NSString *actual, *expected;
    actual = [error localizedDescription], expected = [Digits divideErrorMessage];
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test0PowerNil {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = nil;
    Digits *result = [first power:second withError:NULL];
    STAssertNil(result, @"'%@' should be nil", result);
}

- (void)test0Power0 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");

    NSError *error = nil;
    Digits *result = [first power:second withError:&error];
    
    STAssertNil(result, @"'%@' should be nil", result);
    STAssertNotNil(error, @"'%@' should not be nil", result);
    NSString *actual, *expected;
    actual = [error localizedDescription], expected = [Digits zeroPowerOfZeroErrorMessage];
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test0PowerNegative1 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"-1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    
    NSError *error = nil;
    Digits *result = [first power:second withError:&error];

    STAssertNil(result, @"'%@' should be nil", result);
    STAssertNotNil(error, @"'%@' should not be nil", result);
    NSString *actual, *expected;
    actual = [error localizedDescription], expected = [Digits negativePowerOfZeroErrorMessage];
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegative1PowerPoint5 {
    Digits *first = [[[Digits alloc] initWithString:@"-1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@".5"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    
    NSError *error = nil;
    Digits *result = [first power:second withError:&error];
    
    STAssertNil(result, @"'%@' should be nil", result);
    STAssertNotNil(error, @"'%@' should not be nil", result);
    NSString *actual, *expected;
    actual = [error localizedDescription], expected = [Digits fractionalPowerOfNegativeErrorMessage];
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegative46656Times2 {
    Digits *first = [[[Digits alloc] initWithString:@"-46656"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    
    NSError *error = nil;
    Digits *result = [first times:second withError:&error];
    
    int actual = result.integerValue, expected = -93312;
    STAssertTrue(actual == expected, @"'%qi' should be equal to '%d'", actual, expected);
}

- (void)testNegative46656Power2 {
    Digits *first = [[[Digits alloc] initWithString:@"-46656"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    
    NSError *error = nil;
    Digits *result = [first power:second withError:&error];
    
    int actual = result.integerValue, expected = 2176782336;
    STAssertTrue(actual == expected, @"'%qi' should be equal to '%d'", actual, expected);
}

- (void)test0Invert {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");

    NSError *error = nil;
    Digits *result = [first invertWithError:&error];

    STAssertNil(result, @"'%@' should be nil", result);
    STAssertNotNil(error, @"'%@' should not be nil", result);
    NSString *actual, *expected;
    actual = [error localizedDescription], expected = [Digits invertErrorMessage];
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test0Divide1Divide2 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first divide:second withError:NULL] divide:third withError:NULL];
    int actual = result.integerValue, expected = 0;
    STAssertTrue(actual == expected, @"'%qi' should be equal to '%d'", actual, expected);
}

- (void)test1Divide2Divide3 {
    Digits *first = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"3"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first divide:second withError:NULL] divide:third withError:NULL];
    int actual = result.integerValue, expected = 0;
    STAssertTrue(actual == expected, @"'%qi' should be equal to '%d'", actual, expected);
}

- (void)test3Divide2Divide1 {
    Digits *first = [[[Digits alloc] initWithString:@"3"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first divide:second withError:NULL] divide:third withError:NULL];
    int actual = result.integerValue, expected = 1; // result rounded down from 1.5
    STAssertTrue(actual == expected, @"'%qi' should be equal to '%d'", actual, expected);
}

- (void)test24Divide4DivideNegative3 {
    Digits *first = [[[Digits alloc] initWithString:@"24"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"4"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"-3"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first divide:second withError:NULL] divide:third withError:NULL];
    int actual = result.integerValue, expected = -2;
    STAssertTrue(actual == expected, @"'%qi' should be equal to '%d'", actual, expected);
}

- (void)test0Power1Power2 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first power:second withError:NULL] power:third withError:NULL];
    int actual = result.integerValue, expected = 0;
    STAssertTrue(actual == expected, @"'%qi' should be equal to '%d'", actual, expected);
}

- (void)test1Power2Power3 {
    Digits *first = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"3"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first power:second withError:NULL] power:third withError:NULL];
    int actual = result.integerValue, expected = 1;
    STAssertTrue(actual == expected, @"'%qi' should be equal to '%d'", actual, expected);
}

- (void)test2Power3Power4 {
    Digits *first = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"3"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"4"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first power:second withError:NULL] power:third withError:NULL];
    int actual = result.integerValue, expected = 4096;
    STAssertTrue(actual == expected, @"'%qi' should be equal to '%d'", actual, expected);
}

- (void)testNegate {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test0Negate {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegate0 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    [digits pushDigit:@"0"];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == 0, @"'%qi' should be equal to '%d'", digits.integerValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)test1Negate {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == -1, @"'%qi' should be equal to '%d'", digits.integerValue, -1);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegate1 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    [digits pushDigit:@"1"];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.integerValue == -1, @"'%qi' should be equal to '%d'", digits.integerValue, -1);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert65536ToBase16 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:65536 toBase:16], expected = @"10000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert65535ToBase16 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:65535 toBase:16], expected = @"FFFF";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert65536ToBase2 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:65536 toBase:2], expected = @"10000000000000000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert65535ToBase2 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:65535 toBase:2], expected = @"1111111111111111";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative65536ToBase16 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:-65536 toBase:16], expected = @"-10000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative65535ToBase16 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:-65535 toBase:16], expected = @"-FFFF";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative65536ToBase2 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:-65536 toBase:2], expected = @"-10000000000000000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative65535ToBase2 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:-65535 toBase:2], expected = @"-1111111111111111";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert46656ToBase16 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:46656 toBase:16], expected = @"B640";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative46656ToBase16 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:-46656 toBase:16], expected = @"-B640";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert46656ToBase2 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:46656 toBase:2], expected = @"1011011001000000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative46656ToBase2 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:-46656 toBase:2], expected = @"-1011011001000000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert0ToBase10 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:0 toBase:10], expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative0ToBase10 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:-0 toBase:10], expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert1ToBase10 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:1 toBase:10], expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative1ToBase10 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:-1 toBase:10], expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

@end
