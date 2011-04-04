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
    
    actual = digits.digits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.text, expected = @"0";
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
    
    actual = digits.digits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.text, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithMinus12 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"-12"] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == NO, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == -12, @"");
    
    NSString *actual, *expected;
    
    actual = digits.digits, expected = @"12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.text, expected = @"-12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWith1234567890 {
    
    Digits *digits = [[[Digits alloc] initWithString:@"1234567890"] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 1234567890, @"");
    
    NSString *actual, *expected;
    
    actual = digits.digits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.text, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWith1234567890abc {
    
    Digits *digits = [[[Digits alloc] initWithString:@"1234567890abc"] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == YES, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == 1234567890, @"");
    
    NSString *actual, *expected;
    
    actual = digits.digits, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.text, expected = @"1234567890";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void)testInitWithSpaceMinus123abc456SpaceSpace {
    
    Digits *digits = [[[Digits alloc] initWithString:@"  -123abc456 "] retain];
    STAssertNotNil(digits, @"Cannot create Digits instance");
    STAssertTrue(digits.positive == NO, @"should be positive by default");
    STAssertTrue(digits.base == 10, @"should use decimal base by default");
    STAssertTrue(digits.intValue == -123, @"");
    
    NSString *actual, *expected;
    
    actual = digits.digits, expected = @"123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = digits.text, expected = @"-123";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

//- (void)testFail {
//    
//    STFail(@"this test is meant to fail");
//
//}

@end
