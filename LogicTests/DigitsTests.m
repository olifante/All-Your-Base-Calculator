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
//    digits = [[[Digits alloc] init] retain];
//    STAssertNotNil(digits, @"Cannot create Digits instance");
}

- (void)tearDown
{
//    [digits release];
    NSLog(@"%@ tearDown", self.name);
    
    [super tearDown];
}

- (void)testInit {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 0, @"should be zero by default");
    
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
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 123, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithMinus12 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"-12"] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == NO, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == -12, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWith1234567890 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"1234567890"] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 1234567890, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWith1234567890abc {
    
    Digits *digits = [[[Digits alloc] initWithString:@"1234567890abc"] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 1234567890, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithSpaceMinus123abc456SpaceSpace {
    
    Digits *digits = [[[Digits alloc] initWithString:@"  -123abc456 "] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == NO, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == -123, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush0 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");

    [digits pushDigit:@"0"];
    
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 0, @"should be zero by default");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);

    actual = digits.description, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 1, @"'%@' should be equal to '%d'", digits.intValue, 1);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1And2And3 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];    
    [digits pushDigit:@"2"];    
    [digits pushDigit:@"3"];    

    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 123, @"'%d' should be equal to '%d'", digits.intValue, 123);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush123 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"123"];    
    
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 0, @"'%d' should be equal to '%d'", digits.intValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.signedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);

    actual = digits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1AndA {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];    
    [digits pushDigit:@"A"];    
    
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 1, @"'%d' should be equal to '%d'", digits.intValue, 1);
    
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

- (void)testPush0Pop {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
        
    NSString *actual, *expected;
    
    actual = [digits popDigit], expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);

    actual = digits.unsignedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.signedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1Pop {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    
    NSString *actual, *expected;
    
    actual = [digits popDigit], expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 0, @"'%@' should be equal to '%d'", digits.intValue, 1);
        
    actual = digits.unsignedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.signedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);

    actual = digits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPushMinusPop {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    
    [digits negate];

    STAssertTrue(digits.positive == NO, @"should be positive by default");

    NSString *actual, *expected;
    
    actual = [digits popDigit];
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.unsignedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.signedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1And2And3Pop {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];    
    [digits pushDigit:@"2"];    
    [digits pushDigit:@"3"];

    NSString *actual, *expected;
    
    actual = [digits popDigit], expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
        
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 12, @"'%d' should be equal to '%d'", digits.intValue, 12);
    
    actual = digits.unsignedDigits, expected = @"12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithInt1234567890 {
    
    Digits *digits = [[[Digits alloc] initWithInt:1234567890] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 1234567890, @"'%@' should be equal to '%@'", digits.intValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntMinus1234567890 {
    
    Digits *digits = [[[Digits alloc] initWithInt:-1234567890] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == NO, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == -1234567890, @"'%@' should be equal to '%@'", digits.intValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithInt1234567890Base2 {
    
    Digits *digits = [[[Digits alloc] initWithInt:1234567890 base:2] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 2, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 1234567890, @"'%@' should be equal to '%@'", digits.intValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1001001100101100000001011010010";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1001001100101100000001011010010";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString1001001100101100000001011010010Base2 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"1001001100101100000001011010010" base:2] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 2, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 1234567890, @"'%@' should be equal to '%@'", digits.intValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1001001100101100000001011010010";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1001001100101100000001011010010";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithInt1234567890Base8 {
    
    Digits *digits = [[[Digits alloc] initWithInt:1234567890 base:8] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 8, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 1234567890, @"'%@' should be equal to '%@'", digits.intValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"11145401322";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"11145401322";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWith1234567890Base8 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"11145401322" base:8] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 8, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 1234567890, @"'%@' should be equal to '%@'", digits.intValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"11145401322";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"11145401322";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithInt1234567890Base16 {
    
    Digits *digits = [[[Digits alloc] initWithInt:1234567890 base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 16, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 1234567890, @"'%@' should be equal to '%@'", digits.intValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWith499602D2Base16 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"499602D2" base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 16, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 1234567890, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntMinus1234567890Base16 {
    
    Digits *digits = [[[Digits alloc] initWithInt:-1234567890 base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == NO, @"should be positive by default");
    STAssertTrue(digits.base == 16, @"should use decimal base by default");
    STAssertTrue(digits.intValue == -1234567890, @"'%@' should be equal to '%@'", digits.intValue, 1234567890);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithMinus499602D2Base16 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"-499602D2" base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == NO, @"should be positive by default");
    STAssertTrue(digits.base == 16, @"should use decimal base by default");
    STAssertTrue(digits.intValue == -1234567890, @"");
    
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
    Digits *result = [[first plus:second] plus:third];
    int actual = result.intValue, expected = -1;
    STAssertTrue(actual == expected, @"'%d' should be equal to '%d'", actual, expected);
}

- (void)test0Minus1Minus2 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first minus:second] minus:third];
    int actual = result.intValue, expected = -3;
    STAssertTrue(actual == expected, @"'%d' should be equal to '%d'", actual, expected);
}

- (void)test0Times1Times2 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first times:second] times:third];
    int actual = result.intValue, expected = 0;
    STAssertTrue(actual == expected, @"'%d' should be equal to '%d'", actual, expected);
}

- (void)test1Times2TimesMinus3 {
    Digits *first = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"-3"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *result = [[first times:second] times:third];
    int actual = result.intValue, expected = -6;
    STAssertTrue(actual == expected, @"'%d' should be equal to '%d'", actual, expected);
}

- (void)test0Divide1Divide2 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first divide:second] divide:third];
    int actual = result.intValue, expected = 0;
    STAssertTrue(actual == expected, @"'%d' should be equal to '%d'", actual, expected);
}

- (void)test1Divide2Divide3 {
    Digits *first = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"3"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first divide:second] divide:third];
    int actual = result.intValue, expected = 0;
    STAssertTrue(actual == expected, @"'%d' should be equal to '%d'", actual, expected);
}

- (void)test3Divide2Divide1 {
    Digits *first = [[[Digits alloc] initWithString:@"3"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first divide:second] divide:third];
    int actual = result.intValue, expected = 1; // result rounded down from 1.5
    STAssertTrue(actual == expected, @"'%d' should be equal to '%d'", actual, expected);
}

- (void)test24Divide4DivideMinus3 {
    Digits *first = [[[Digits alloc] initWithString:@"24"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"4"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"-3"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first divide:second] divide:third];
    int actual = result.intValue, expected = -2;
    STAssertTrue(actual == expected, @"'%d' should be equal to '%d'", actual, expected);
}

- (void)test0Power1Power2 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first power:second] power:third];
    int actual = result.intValue, expected = 0;
    STAssertTrue(actual == expected, @"'%d' should be equal to '%d'", actual, expected);
}

- (void)test1Power2Power3 {
    Digits *first = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"3"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first power:second] power:third];
    int actual = result.intValue, expected = 1;
    STAssertTrue(actual == expected, @"'%d' should be equal to '%d'", actual, expected);
}

- (void)test2Power3Power4 {
    Digits *first = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"3"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"4"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = [[first power:second] power:third];
    int actual = result.intValue, expected = 4096;
    STAssertTrue(actual == expected, @"'%d' should be equal to '%d'", actual, expected);
}

- (void)testNegate {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    
    STAssertTrue(digits.positive == NO, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 0, @"'%@' should be equal to '%d'", digits.intValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.signedDigits, expected = @"-";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush0Negate {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
    [digits negate];
    
    STAssertTrue(digits.positive == NO, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 0, @"'%@' should be equal to '%d'", digits.intValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegatePush0 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    [digits pushDigit:@"0"];
    
    STAssertTrue(digits.positive == NO, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 0, @"'%@' should be equal to '%d'", digits.intValue, 0);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1Negate {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    [digits negate];
    
    STAssertTrue(digits.positive == NO, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == -1, @"'%@' should be equal to '%d'", digits.intValue, -1);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegatePush1 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    [digits pushDigit:@"1"];
    
    STAssertTrue(digits.positive == NO, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == -1, @"'%@' should be equal to '%d'", digits.intValue, -1);
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

@end
