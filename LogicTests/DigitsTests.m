//
//  DigitsTests.m
//  AllYourBase
//
//  Created by Tiago Henriques on 4/4/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "DigitsTests.h"

@implementation DigitsTests

- (void)setUp {
    [super setUp];
    
    NSLog(@"%@ setUp", self.name);
}

- (void)tearDown {
    NSLog(@"%@ tearDown", self.name);
    
    [super tearDown];
}

- (void)testConvert0Point1ToBase10 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:0.1 toBase:10], expected = @"0"; // and not 0.1
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert0ToBase10 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:0 toBase:10], expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert10Point1ToBase10 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:10.1 toBase:10], expected = @"10"; // and not 10.1
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert1Point1ToBase10 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:1.1 toBase:10], expected = @"1"; // and not 1.1
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert1ToBase10 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:1 toBase:10], expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert46656ToBase16 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:46656 toBase:16], expected = @"B640";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert46656ToBase2 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:46656 toBase:2], expected = @"1011011001000000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert65535ToBase16 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:65535 toBase:16], expected = @"FFFF";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert65535ToBase2 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:65535 toBase:2], expected = @"1111111111111111";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert65536ToBase16 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:65536 toBase:16], expected = @"10000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert65536ToBase2 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:65536 toBase:2], expected = @"10000000000000000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative0Point1ToBase10 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:-0.1 toBase:10], expected = @"0"; // and not -0.1
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative0ToBase10 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:-0 toBase:10], expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative1ToBase10 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:-1 toBase:10], expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative10PointToBase10 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:-10.1 toBase:10], expected = @"-10"; // and not -10.1
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative1Point1ToBase10 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:-1.1 toBase:10], expected = @"-1"; // and not -1.1
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative46656ToBase16 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:-46656 toBase:16], expected = @"-B640";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative46656ToBase2 {
    NSString *actual, *expected;
    actual = [Digits convertInteger:-46656 toBase:2], expected = @"-1011011001000000";
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

- (void)testInit {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.signedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegral0 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:0] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegral0x7fffffff { // maximum int value on 32 bits architectures like the iPhone
    
    Digits *digits = [[[Digits alloc] initWithLongLong:0x7fffffff] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0x7fffffffLL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483647";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"2147483647";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegral0x7fffffffLL { // maximum int value on 32 bits architectures like the iPhone
    
    Digits *digits = [[[Digits alloc] initWithLongLong:0x7fffffffLL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0x7fffffffLL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483647";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"2147483647";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegral0x80000000 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:0x80000000] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0x80000000LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegral0x80000000LL {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:0x80000000LL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0x80000000LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegral0x1000000000000000LL {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:0x1000000000000000LL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0x1000000000000000LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1152921504606846976";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1152921504606846976";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegral0x2000000000000000LL {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:0x2000000000000000LL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0x2000000000000000LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2305843009213693952";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"2305843009213693952";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegral0x2000000000000000LLbase16 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:0x2000000000000000LL base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 16, @"");
    STAssertEquals(digits.integerValue, 0x2000000000000000LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2000000000000000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"2000000000000000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegral0x4000000000000000LL {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:0x4000000000000000LL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0x4000000000000000LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"4611686018427387904";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"4611686018427387904";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegral0x8000000000000000LL {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:0x8000000000000000LL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0x8000000000000000LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"9223372036854775808";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"9223372036854775808";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegralNegative0x8000000000000000LL {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:-0x8000000000000000LL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, -0x8000000000000000LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"9223372036854775808";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-9223372036854775808";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegral1234567890 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:1234567890] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 1234567890LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegral1234567890Base16 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:1234567890 base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 16, @"should use decimal base by default");
    STAssertEquals(digits.integerValue, 1234567890LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegral1234567890Base2 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:1234567890 base:2] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 2, @"should use decimal base by default");
    STAssertEquals(digits.integerValue, 1234567890LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1001001100101100000001011010010";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1001001100101100000001011010010";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegral1234567890Base8 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:1234567890 base:8] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 8, @"should use decimal base by default");
    STAssertEquals(digits.integerValue, 1234567890LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"11145401322";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"11145401322";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegralNegative0x80000000 { // minimum int value on 32 bits architectures like the iPhone
    
    Digits *digits = [[[Digits alloc] initWithLongLong:-0x80000000] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, -0x80000000LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegralNegative0x80000000LL { // minimum int value on 32 bits architectures like the iPhone
    
    Digits *digits = [[[Digits alloc] initWithLongLong:-0x80000000LL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, -0x80000000LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegralNegative0x80000001 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:-0x80000001] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, -0x80000001LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483649";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-2147483649";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegralNegative0x80000001LL {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:-0x80000001LL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, -0x80000001LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483649";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-2147483649";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegralNegative1234567890 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:-1234567890] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, -1234567890LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegralNegative1234567890Base16 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:-1234567890 base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 16, @"should use decimal base by default");
    STAssertEquals(digits.integerValue, -1234567890LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithIntegralNegative46656 {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:-46656] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, -46656LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"46656";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-46656";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString0Divide1Divide2 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = (Digits *)[[first divide:second withError:NULL] divide:third withError:NULL];
    double actual = result.integerValue, expected = 0.;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString0Invert {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    
    NSError *error = nil;
    Digits *result = (Digits *)[first invertWithError:&error];
    
    STAssertNil(result, @"'%@' should be nil", result);
    STAssertNotNil(error, @"'%@' should not be nil", result);
    NSString *actual, *expected;
    actual = [error localizedDescription], expected = [Digits invertErrorMessage];
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString0Plus1PlusMinus2 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"-2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = (Digits *)[[first plus:second withError:NULL] plus:third withError:NULL];
    double actual = result.integerValue, expected = -1.0;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString0Minus1Minus2 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = (Digits *)[[first minus:second withError:NULL] minus:third withError:NULL];
    double actual = result.integerValue, expected = -3.0;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString0Times1Times2 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = (Digits *)[[first times:second withError:NULL] times:third withError:NULL];
    double actual = result.integerValue, expected = 0.0;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString0Point1 {
    Digits *digits = [[[Digits alloc] initWithString:@"0.1"] autorelease];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    double actual = digits.integerValue, expected = 0.0; // and not 0.1
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString0Point1Times1 {
    Digits *first = [[[Digits alloc] initWithString:@"0.1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *result = (Digits *)[first times:second withError:NULL];
    double actual = result.integerValue, expected = 0.0; // and not 0.1
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString0PowerNil {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = nil;
    Digits *result = (Digits *)[first power:second withError:NULL];
    STAssertNil(result, @"'%@' should be nil", result);
}

- (void)testInitWithString0Power0 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    
    NSError *error = nil;
    Digits *result = (Digits *)[first power:second withError:&error];
    
    STAssertNil(result, @"'%@' should be nil", result);
    STAssertNotNil(error, @"'%@' should not be nil", result);
    NSString *actual, *expected;
    actual = [error localizedDescription], expected = [Digits zeroPowerOfZeroErrorMessage];
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString0PowerNegative1 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"-1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    
    NSError *error = nil;
    Digits *result = (Digits *)[first power:second withError:&error];
    
    STAssertNil(result, @"'%@' should be nil", result);
    STAssertNotNil(error, @"'%@' should not be nil", result);
    NSString *actual, *expected;
    actual = [error localizedDescription], expected = [Digits negativePowerOfZeroErrorMessage];
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString0Power1Power2 {
    Digits *first = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = (Digits *)[[first power:second withError:NULL] power:third withError:NULL];
    double actual = result.integerValue, expected = 0.;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString1Power2Power3 {
    Digits *first = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"3"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = (Digits *)[[first power:second withError:NULL] power:third withError:NULL];
    double actual = result.integerValue, expected = 1.;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString1073741824Times2 {
    Digits *first = [[[Digits alloc] initWithString:@"1073741824"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *result = (Digits *)[first times:second withError:NULL];
    double actual = result.integerValue, expected = 0x80000000;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString1Point1 {
    Digits *digits = [[[Digits alloc] initWithString:@"1.1"] autorelease];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    double actual = digits.integerValue, expected = 1.0; // and not 1.1
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString1Point1Times2 {
    Digits *first = [[[Digits alloc] initWithString:@"1.1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *result = (Digits *)[first times:second withError:NULL];
    double actual = result.integerValue, expected = 2.0; // and not 2.2
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString1Times2TimesMinus3 {
    Digits *first = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"-3"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *result = (Digits *)[[first times:second withError:NULL] times:third withError:NULL];
    double actual = result.integerValue, expected = -6.0;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString1TimesNil {
    Digits *first = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = nil;
    Digits *result = (Digits *)[first times:second withError:NULL];
    STAssertNil(result, @"'%@' should be nil", result);
}

- (void)testInitWithString1DivideNil {
    Digits *first = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = nil;
    Digits *result = (Digits *)[first divide:second withError:NULL];
    STAssertNil(result, @"'%@' should be nil", result);
}

- (void)testInitWithString1Divide0 {
    Digits *first = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    
    NSError *error = nil;
    Digits *result = (Digits *)[first divide:second withError:&error];
    
    STAssertNil(result, @"'%@' should be nil", result);
    STAssertNotNil(error, @"'%@' should not be nil", result);
    NSString *actual, *expected;
    actual = [error localizedDescription], expected = [Digits divideErrorMessage];
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString1234567890 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"1234567890"] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 1234567890LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString1234567890abc {
    
    Digits *digits = [[[Digits alloc] initWithString:@"1234567890abc"] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 1234567890LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString1001001100101100000001011010010Base2 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"1001001100101100000001011010010" base:2] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 2, @"should use decimal base by default");
    STAssertEquals(digits.integerValue, 1234567890LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1001001100101100000001011010010";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1001001100101100000001011010010";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString1234567890Base8 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"11145401322" base:8] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 8, @"should use decimal base by default");
    STAssertEquals(digits.integerValue, 1234567890LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"11145401322";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"11145401322";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString1Divide2Divide3 {
    Digits *first = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"3"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = (Digits *)[[first divide:second withError:NULL] divide:third withError:NULL];
    double actual = result.integerValue, expected = 0.166667;
    STAssertEqualsWithAccuracy(actual, expected, 1, @"");
}

- (void)testInitWithString24Divide4DivideNegative3 {
    Digits *first = [[[Digits alloc] initWithString:@"24"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"4"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"-3"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = (Digits *)[[first divide:second withError:NULL] divide:third withError:NULL];
    double actual = result.integerValue, expected = -2.;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString2Power3Power4 {
    Digits *first = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"3"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"4"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = (Digits *)[[first power:second withError:NULL] power:third withError:NULL];
    double actual = result.integerValue, expected = 4096.;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString2Power61 {
    Digits *first = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"61"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *result = (Digits *)[first power:second withError:NULL];
    double actual = result.integerValue, expected = 0x2000000000000000LL;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString2Power62 {
    Digits *first = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"62"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *result = (Digits *)[first power:second withError:NULL];
    double actual = result.integerValue, expected = 0x4000000000000000LL;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString2Power63 {
    Digits *first = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"63"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *result = (Digits *)[first power:second withError:NULL];
    double actual = result.integerValue, expected = 0x8000000000000000LL;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString2Power61Times2 {
    Digits *first = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"61"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = (Digits *)[[first power:second withError:NULL] times:third withError:NULL];
    double actual = result.integerValue, expected = 0x4000000000000000LL;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString2Power62Times2 {
    Digits *first = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"62"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = (Digits *)[[first power:second withError:NULL] times:third withError:NULL];
    double actual = result.integerValue, expected = 0x8000000000000000LL;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString3Divide2Divide1 {
    Digits *first = [[[Digits alloc] initWithString:@"3"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    Digits *third = [[[Digits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    Digits *result = (Digits *)[[first divide:second withError:NULL] divide:third withError:NULL];
    double actual = result.integerValue, expected = 1.0; // and not 1.5
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString499602D2Base16 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"499602D2" base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 16, @"should use decimal base by default");
    STAssertEquals(digits.integerValue, 1234567890LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithStringNegative12 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"-12"] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, -12LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithStringNegative499602D2Base16 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"-499602D2" base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 16, @"should use decimal base by default");
    STAssertEquals(digits.integerValue, -1234567890LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithStringNegative1PowerPoint5 {
    Digits *first = [[[Digits alloc] initWithString:@"-1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@".5"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    
    NSError *error = nil;
    Digits *result = (Digits *)[first power:second withError:&error];
    
    STAssertNil(result, @"'%@' should be nil", result);
    STAssertNotNil(error, @"'%@' should not be nil", result);
    NSString *actual, *expected;
    actual = [error localizedDescription], expected = [Digits fractionalPowerOfNegativeErrorMessage];
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithStringNegative46656Times2 {
    Digits *first = [[[Digits alloc] initWithString:@"-46656"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    
    NSError *error = nil;
    Digits *result = (Digits *)[first times:second withError:&error];
    
    double actual = result.integerValue, expected = -93312;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithStringNegative46656Power2 {
    Digits *first = [[[Digits alloc] initWithString:@"-46656"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    Digits *second = [[[Digits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    
    NSError *error = nil;
    Digits *result = (Digits *)[first power:second withError:&error];
    
    double actual = result.integerValue, expected = 2176782336.;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithStringNil {
    Digits *digits = [[[Digits alloc] initWithString:nil] retain];
    STAssertNil(digits, @"Should not be able to create Digits instance");
}

- (void)testInitWithStringNilBase1 {
    Digits *digits = [[[Digits alloc] initWithString:@"" base:1] retain];
    STAssertNil(digits, @"Should not be able to create Digits instance");
}

- (void)testInitWithStringSpace123SpaceSpace {
    
    Digits *digits = [[[Digits alloc] initWithString:@"  123 "] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 123LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithStringSpaceNegative123abc456SpaceSpace {
    
    Digits *digits = [[[Digits alloc] initWithString:@"  -123abc456 "] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, -123LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegate {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegateNegative0x8000000000000000LL {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:-0x8000000000000000LL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");

    [digits negate];

    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, -0x8000000000000000LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"9223372036854775808";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-9223372036854775808";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegate0x7FFFFFFFFFFFFFFFLL {
    
    Digits *digits = [[[Digits alloc] initWithLongLong:0x7FFFFFFFFFFFFFFFLL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, -0x7FFFFFFFFFFFFFFFLL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"9223372036854775807";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-9223372036854775807";
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

- (void)testNegatePush0 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    [digits pushDigit:@"0"];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegatePush1 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    [digits pushDigit:@"1"];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, -1LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegatePushPoint {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    [digits pushDigit:@"."];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegatePushPoint2 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    [digits pushDigit:@"."];
    [digits pushDigit:@"2"];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEqualsWithAccuracy(digits.integerValue, 0LL, 1, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0.2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0.2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush0 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush00 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
    [digits pushDigit:@"0"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush0Point {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
    [digits pushDigit:@"."];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush0Pop {
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

- (void)testPush0Point1 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
    [digits pushDigit:@"."];
    [digits pushDigit:@"1"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0.1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0.1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush0Negate {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 1LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1Point {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    [digits pushDigit:@"."];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 1LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"1.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1Point2 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    [digits pushDigit:@"."];
    [digits pushDigit:@"2"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 1LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1.2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1.2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"1.2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1And2And3 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];    
    [digits pushDigit:@"2"];    
    [digits pushDigit:@"3"];    
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 123LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush9And0And0And0And0And0And0And0And0And0And0And0And0And0And0And0And0And0And0 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"9"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 9000000000000000000LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"9000000000000000000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"9000000000000000000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush9And0And0And0And0And0And0And0And0And0And0And0And0And0And0And0And0And0And0And0 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"9"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    [digits pushDigit:@"0"];    
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 9000000000000000000LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"9000000000000000000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"9000000000000000000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush123 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"123"];    
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0LL, @"");
    
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
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 1LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1Pop {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    
    NSString *actual, *expected;
    
    actual = [digits popDigit], expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0LL, @"");
    
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
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 12LL, @"");
    
    actual = digits.unsignedDigits, expected = @"12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1Negate {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, -1LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPushPoint {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"."];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPushPointPoint {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"."];
    [digits pushDigit:@"."];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPushPoint3 {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"."];
    [digits pushDigit:@"3"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEqualsWithAccuracy(digits.integerValue, 0LL, 1, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0.3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0.3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPushPoint5Negate {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"."];
    [digits pushDigit:@"5"];
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEqualsWithAccuracy(digits.integerValue, 0LL, 1, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.5";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0.5";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0.5";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPushPointNegate {
    Digits *digits = [[[Digits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"."];
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.integerValue, 0LL, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPushPop {
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

@end
