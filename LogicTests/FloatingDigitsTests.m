//
//  FloatingDigitsTests.m
//  AllYourBase
//
//  Created by Tiago Henriques on 4/16/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "FloatingDigitsTests.h"


@implementation FloatingDigitsTests

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

- (void)testConvert0Point1ToBase10 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:0.1 toBase:10], expected = @"0.1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert0ToBase10 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:0 toBase:10], expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert10Point1ToBase10 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:10.1 toBase:10], expected = @"10.1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert1Point1ToBase10 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:1.1 toBase:10], expected = @"1.1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert1ToBase10 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:1 toBase:10], expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert46656ToBase16 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:46656 toBase:16], expected = @"B640";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert46656ToBase2 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:46656 toBase:2], expected = @"1011011001000000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert65535ToBase16 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:65535 toBase:16], expected = @"FFFF";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert65535ToBase2 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:65535 toBase:2], expected = @"1111111111111111";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert65536ToBase16 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:65536 toBase:16], expected = @"10000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvert65536ToBase2 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:65536 toBase:2], expected = @"10000000000000000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative0Point1ToBase10 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:-0.1 toBase:10], expected = @"-0.1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative0ToBase10 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:-0 toBase:10], expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative1ToBase10 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:-1 toBase:10], expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative10PointToBase10 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:-10.1 toBase:10], expected = @"-10.1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative1Point1ToBase10 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:-1.1 toBase:10], expected = @"-1.1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative46656ToBase16 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:-46656 toBase:16], expected = @"-B640";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative46656ToBase2 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:-46656 toBase:2], expected = @"-1011011001000000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative65536ToBase16 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:-65536 toBase:16], expected = @"-10000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative65535ToBase16 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:-65535 toBase:16], expected = @"-FFFF";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative65536ToBase2 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:-65536 toBase:2], expected = @"-10000000000000000";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testConvertNegative65535ToBase2 {
    NSString *actual, *expected;
    actual = [FloatingDigits convertDouble:-65535 toBase:2], expected = @"-1111111111111111";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInit {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.signedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithDouble0 {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithDouble:0] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithDouble0x7fffffff { // maximum int value on 32 bits architectures like the iPhone
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithDouble:0x7fffffff.p0] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0x7fffffff.p0, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483647";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"2147483647";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithDouble0x7fffffffLL { // maximum int value on 32 bits architectures like the iPhone
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithDouble:0x7fffffffLL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0x7fffffff.p0, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483647";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"2147483647";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithDouble0x80000000 {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithDouble:0x80000000.p0] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0x80000000.p0, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithDouble0x80000000LL {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithDouble:0x80000000LL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0x80000000.p0, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithDouble1234567890 {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithDouble:1234567890] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 1234567890., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithDouble1234567890Base16 {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithDouble:1234567890 base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 16, @"should use decimal base by default");
    STAssertEquals(digits.doubleValue, 1234567890., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithDouble1234567890Base2 {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithDouble:1234567890 base:2] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 2, @"should use decimal base by default");
    STAssertEquals(digits.doubleValue, 1234567890., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1001001100101100000001011010010";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1001001100101100000001011010010";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithDouble1234567890Base8 {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithDouble:1234567890 base:8] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 8, @"should use decimal base by default");
    STAssertEquals(digits.doubleValue, 1234567890., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"11145401322";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"11145401322";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithDoubleNegative0x80000000 { // minimum int value on 32 bits architectures like the iPhone
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithDouble:-0x80000000.p0] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, -0x80000000.p0, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithDoubleNegative0x80000000LL { // minimum int value on 32 bits architectures like the iPhone
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithDouble:-0x80000000LL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, -0x80000000.p0, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-2147483648";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithDoubleNegative0x80000001 {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithDouble:-0x80000001.p0] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, -0x80000001.p0, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483649";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-2147483649";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithDoubleNegative0x80000001LL {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithDouble:-0x80000001LL] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, -0x80000001.p0, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"2147483649";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-2147483649";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithDoubleNegative1234567890 {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithDouble:-1234567890] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, -1234567890., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithDoubleNegative1234567890Base16 {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithDouble:-1234567890 base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 16, @"should use decimal base by default");
    STAssertEquals(digits.doubleValue, -1234567890., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithDoubleNegative46656 {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithDouble:-46656] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, -46656., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"46656";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-46656";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString0Divide1Divide2 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    FloatingDigits *third = [[[FloatingDigits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    FloatingDigits *result = (FloatingDigits *)[[first divide:second withError:NULL] divide:third withError:NULL];
    double actual = result.doubleValue, expected = 0.;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString0Invert {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    
    NSError *error = nil;
    FloatingDigits *result = (FloatingDigits *)[first invertWithError:&error];
    
    STAssertNil(result, @"'%@' should be nil", result);
    STAssertNotNil(error, @"'%@' should not be nil", result);
    NSString *actual, *expected;
    actual = [error localizedDescription], expected = [Digits invertErrorMessage];
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString0Plus1PlusMinus2 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    FloatingDigits *third = [[[FloatingDigits alloc] initWithString:@"-2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    FloatingDigits *result = (FloatingDigits *)[[first plus:second withError:NULL] plus:third withError:NULL];
    double actual = result.doubleValue, expected = -1.0;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString0Minus1Minus2 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    FloatingDigits *third = [[[FloatingDigits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    FloatingDigits *result = (FloatingDigits *)[[first minus:second withError:NULL] minus:third withError:NULL];
    double actual = result.doubleValue, expected = -3.0;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString0Times1Times2 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    FloatingDigits *third = [[[FloatingDigits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    FloatingDigits *result = (FloatingDigits *)[[first times:second withError:NULL] times:third withError:NULL];
    double actual = result.doubleValue, expected = 0.0;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString0Point1 {
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithString:@"0.1"] autorelease];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    double actual = digits.doubleValue, expected = 0.1;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString0Point1Times1 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"0.1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    FloatingDigits *result = (FloatingDigits *)[first times:second withError:NULL];
    double actual = result.doubleValue, expected = 0.1;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString0PowerNil {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = nil;
    FloatingDigits *result = (FloatingDigits *)[first power:second withError:NULL];
    STAssertNil(result, @"'%@' should be nil", result);
}

- (void)testInitWithString0Power0 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    
    NSError *error = nil;
    FloatingDigits *result = (FloatingDigits *)[first power:second withError:&error];
    
    STAssertNil(result, @"'%@' should be nil", result);
    STAssertNotNil(error, @"'%@' should not be nil", result);
    NSString *actual, *expected;
    actual = [error localizedDescription], expected = [Digits zeroPowerOfZeroErrorMessage];
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString0PowerNegative1 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"-1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    
    NSError *error = nil;
    FloatingDigits *result = (FloatingDigits *)[first power:second withError:&error];
    
    STAssertNil(result, @"'%@' should be nil", result);
    STAssertNotNil(error, @"'%@' should not be nil", result);
    NSString *actual, *expected;
    actual = [error localizedDescription], expected = [Digits negativePowerOfZeroErrorMessage];
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString0Power1Power2 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    FloatingDigits *third = [[[FloatingDigits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    FloatingDigits *result = (FloatingDigits *)[[first power:second withError:NULL] power:third withError:NULL];
    double actual = result.doubleValue, expected = 0.;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString1Power2Power3 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    FloatingDigits *third = [[[FloatingDigits alloc] initWithString:@"3"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    FloatingDigits *result = (FloatingDigits *)[[first power:second withError:NULL] power:third withError:NULL];
    double actual = result.doubleValue, expected = 1.;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString1073741824Times2 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"1073741824"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    FloatingDigits *result = (FloatingDigits *)[first times:second withError:NULL];
    double actual = result.doubleValue, expected = 0x80000000.p0;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString1Point1 {
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithString:@"1.1"] autorelease];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    double actual = digits.doubleValue, expected = 1.1;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString1Point1Times2 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"1.1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    FloatingDigits *result = (FloatingDigits *)[first times:second withError:NULL];
    double actual = result.doubleValue, expected = 2.2;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString1Times2TimesMinus3 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    FloatingDigits *third = [[[FloatingDigits alloc] initWithString:@"-3"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    FloatingDigits *result = (FloatingDigits *)[[first times:second withError:NULL] times:third withError:NULL];
    double actual = result.doubleValue, expected = -6.0;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString1TimesNil {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = nil;
    FloatingDigits *result = (FloatingDigits *)[first times:second withError:NULL];
    STAssertNil(result, @"'%@' should be nil", result);
}

- (void)testInitWithString1DivideNil {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = nil;
    FloatingDigits *result = (FloatingDigits *)[first divide:second withError:NULL];
    STAssertNil(result, @"'%@' should be nil", result);
}

- (void)testInitWithString1Divide0 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"0"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    
    NSError *error = nil;
    FloatingDigits *result = (FloatingDigits *)[first divide:second withError:&error];
    
    STAssertNil(result, @"'%@' should be nil", result);
    STAssertNotNil(error, @"'%@' should not be nil", result);
    NSString *actual, *expected;
    actual = [error localizedDescription], expected = [Digits divideErrorMessage];
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString1234567890 {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithString:@"1234567890"] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 1234567890., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString1234567890abc {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithString:@"1234567890abc"] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 1234567890., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString1001001100101100000001011010010Base2 {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithString:@"1001001100101100000001011010010" base:2] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 2, @"should use decimal base by default");
    STAssertEquals(digits.doubleValue, 1234567890., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1001001100101100000001011010010";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1001001100101100000001011010010";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString1234567890Base8 {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithString:@"11145401322" base:8] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 8, @"should use decimal base by default");
    STAssertEquals(digits.doubleValue, 1234567890., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"11145401322";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"11145401322";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithString1Divide2Divide3 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    FloatingDigits *third = [[[FloatingDigits alloc] initWithString:@"3"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    FloatingDigits *result = (FloatingDigits *)[[first divide:second withError:NULL] divide:third withError:NULL];
    double actual = result.doubleValue, expected = 0.166667;
    STAssertEqualsWithAccuracy(actual, expected, 0.0000000000000001, @"");
}

- (void)testInitWithString24Divide4DivideNegative3 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"24"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"4"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    FloatingDigits *third = [[[FloatingDigits alloc] initWithString:@"-3"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    FloatingDigits *result = (FloatingDigits *)[[first divide:second withError:NULL] divide:third withError:NULL];
    double actual = result.doubleValue, expected = -2.;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString2Power3Power4 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"3"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    FloatingDigits *third = [[[FloatingDigits alloc] initWithString:@"4"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    FloatingDigits *result = (FloatingDigits *)[[first power:second withError:NULL] power:third withError:NULL];
    double actual = result.doubleValue, expected = 4096.;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString3Divide2Divide1 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"3"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    FloatingDigits *third = [[[FloatingDigits alloc] initWithString:@"1"] autorelease];
    STAssertNotNil(third, @"Cannot create Digits instance");
    FloatingDigits *result = (FloatingDigits *)[[first divide:second withError:NULL] divide:third withError:NULL];
    double actual = result.doubleValue, expected = 1.5;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithString499602D2Base16 {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithString:@"499602D2" base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertTrue(digits.base == 16, @"should use decimal base by default");
    STAssertEquals(digits.doubleValue, 1234567890., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithStringNegative12 {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithString:@"-12"] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, -12., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithStringNegative499602D2Base16 {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithString:@"-499602D2" base:16] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertTrue(digits.base == 16, @"should use decimal base by default");
    STAssertEquals(digits.doubleValue, -1234567890., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-499602D2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithStringNegative1PowerPoint5 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"-1"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@".5"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    
    NSError *error = nil;
    FloatingDigits *result = (FloatingDigits *)[first power:second withError:&error];
    
    STAssertNil(result, @"'%@' should be nil", result);
    STAssertNotNil(error, @"'%@' should not be nil", result);
    NSString *actual, *expected;
    actual = [error localizedDescription], expected = [Digits fractionalPowerOfNegativeErrorMessage];
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithStringNegative46656Times2 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"-46656"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    
    NSError *error = nil;
    FloatingDigits *result = (FloatingDigits *)[first times:second withError:&error];
    
    double actual = result.doubleValue, expected = -93312;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithStringNegative46656Power2 {
    FloatingDigits *first = [[[FloatingDigits alloc] initWithString:@"-46656"] autorelease];
    STAssertNotNil(first, @"Cannot create Digits instance");
    FloatingDigits *second = [[[FloatingDigits alloc] initWithString:@"2"] autorelease];
    STAssertNotNil(second, @"Cannot create Digits instance");
    
    NSError *error = nil;
    FloatingDigits *result = (FloatingDigits *)[first power:second withError:&error];
    
    double actual = result.doubleValue, expected = 2176782336.;
    STAssertEquals(actual, expected, @"");
}

- (void)testInitWithStringNil {
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithString:nil] retain];
    STAssertNil(digits, @"Should not be able to create Digits instance");
}

- (void)testInitWithStringNilBase1 {
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithString:@"" base:1] retain];
    STAssertNil(digits, @"Should not be able to create Digits instance");
}

- (void)testInitWithStringSpace123SpaceSpace {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithString:@"  123 "] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 123., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithStringSpaceNegative123abc456SpaceSpace {
    
    FloatingDigits *digits = [[[FloatingDigits alloc] initWithString:@"  -123abc456 "] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, -123., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegate {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegatePop {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
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
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
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
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    [digits pushDigit:@"0"];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegatePush1 {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    [digits pushDigit:@"1"];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, -1., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegatePushPoint {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    [digits pushDigit:@"."];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testNegatePushPoint2 {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits negate];
    [digits pushDigit:@"."];
    [digits pushDigit:@"2"];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEqualsWithAccuracy(digits.doubleValue, -0.2, 0.0000000000000001, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0.2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0.2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush0 {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush00 {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
    [digits pushDigit:@"0"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush0Point {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
    [digits pushDigit:@"."];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush0Pop {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
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
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
    [digits pushDigit:@"."];
    [digits pushDigit:@"1"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0.1, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0.1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0.1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush0Negate {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"0"];
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1 {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 1., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1Point {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    [digits pushDigit:@"."];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 1., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"1.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1Point2 {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    [digits pushDigit:@"."];
    [digits pushDigit:@"2"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 1.2, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1.2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1.2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"1.2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1And2And3 {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];    
    [digits pushDigit:@"2"];    
    [digits pushDigit:@"3"];    
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 123., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush123 {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"123"];    
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.signedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1AndA {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];    
    [digits pushDigit:@"A"];    
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 1., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1Pop {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    
    NSString *actual, *expected;
    
    actual = [digits popDigit], expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0., @"");
    
    actual = digits.unsignedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.signedDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = digits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1And2And3Pop {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];    
    [digits pushDigit:@"2"];    
    [digits pushDigit:@"3"];
    
    NSString *actual, *expected;
    
    actual = [digits popDigit], expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 12., @"");
    
    actual = digits.unsignedDigits, expected = @"12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPush1Negate {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"1"];
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, -1., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPushPoint {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"."];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPushPointPoint {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"."];
    [digits pushDigit:@"."];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPushPoint3 {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"."];
    [digits pushDigit:@"3"];
    
    STAssertTrue(digits.startsWithMinus == NO, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEqualsWithAccuracy(digits.doubleValue, 0.3, 0.0000000000000001, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"0.3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"0.3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPushPoint5Negate {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"."];
    [digits pushDigit:@"5"];
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEqualsWithAccuracy(digits.doubleValue, -0.5, 0.0000000000000001, @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.5";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0.5";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0.5";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPushPointNegate {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    
    [digits pushDigit:@"."];
    [digits negate];
    
    STAssertTrue(digits.startsWithMinus == YES, @"");
    STAssertEquals(digits.base, 10, @"");
    STAssertEquals(digits.doubleValue, 0., @"");
    
    NSString *actual, *expected;
    
    actual = digits.unsignedDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.signedDigits, expected = @"-0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.description, expected = @"-0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testPushPop {
    FloatingDigits *digits = [[[FloatingDigits alloc] init] retain];
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
