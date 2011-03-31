//
//  LogicTests.m
//  LogicTests
//
//  Created by Tiago Henriques on 3/30/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "LogicTests.h"


@implementation LogicTests

- (void)setUp
{
    [super setUp];
    
    NSLog(@"%@ setUp", self.name);
    calculator = [[[AllYourBaseModel alloc] init] retain];
    STAssertNotNil(calculator, @"Cannot create Calculator instance");
}

- (void)tearDown
{
    [calculator release];
    NSLog(@"%@ tearDown", self.name);
    
    [super tearDown];
}

- (void) testAddition {
    [calculator digitPressed:@"6"];
    [calculator operationPressed:@"+"];
    [calculator digitPressed:@"2"];
    [calculator resultPressed];
    NSString *actual, *expected;

    actual = calculator.result, expected = @"8";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) testDivision {
    [calculator digitPressed:@"1"];
    [calculator digitPressed:@"9"];
    [calculator operationPressed:@"/"];
    [calculator digitPressed:@"8"];
    [calculator resultPressed];
    NSString *actual, *expected;
    
    actual = calculator.result, expected = @"2.375";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) testInit {
    NSString *actual;
    
    actual = calculator.previousDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.result;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.firstDisplay;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondDisplay;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
}

- (void) testDigit {
    [calculator digitPressed:@"1"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.result;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.firstDisplay;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondDisplay;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
}

- (void) testDigitOperation {
    [calculator digitPressed:@"1"];
    [calculator operationPressed:@"+"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentOperation, expected = @"+";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.result;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.firstDisplay;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondDisplay;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
}

- (void) testDigitOperationDigit {
    [calculator digitPressed:@"1"];
    [calculator operationPressed:@"+"];
    [calculator digitPressed:@"2"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits, expected = @"2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"+";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.result;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.firstDisplay;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondDisplay;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
}

- (void) testDigitOperationDigitOperation {
    [calculator digitPressed:@"1"];
    [calculator operationPressed:@"+"];
    [calculator digitPressed:@"2"];
    [calculator operationPressed:@"*"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits, expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentOperation, expected = @"*";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation, expected = @"+";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"1 + 2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.result, expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.firstDisplay;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondDisplay;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
}

- (void) testDigitOperationDigitOperationDigit {
    [calculator digitPressed:@"1"];
    [calculator operationPressed:@"+"];
    [calculator digitPressed:@"2"];
    [calculator operationPressed:@"*"];
    [calculator digitPressed:@"4"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits, expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits, expected = @"4";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"*";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression, expected = @"1 + 2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.result, expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.firstDisplay;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondDisplay;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
}

/*
- (void) testInputException {
    NSLog(@"%@ start", self.name);
	STAssertThrows([calculator digitPressed:@"67"], @"No exception for multicharacter input.");
	STAssertThrows([calculator operationPressed:@"j"],  @"No exception for invalid input.");
	STAssertThrows([calculator digitPressed:nil],   @"No exception for nil input.");
	STAssertThrows([calculator operationPressed:nil],   @"No exception for nil input.");
    NSLog(@"%@ end", self.name);
}
 */

- (void) testMultiplication {
    [calculator digitPressed:@"6"];
    [calculator operationPressed:@"*"];
    [calculator digitPressed:@"2"];
    [calculator resultPressed];
    NSString *actual, *expected;
    actual = calculator.result, expected = @"12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) testSubtraction {
    [calculator digitPressed:@"1"];
    [calculator digitPressed:@"9"];
    [calculator operationPressed:@"-"];
    [calculator digitPressed:@"2"];
    [calculator resultPressed];
    NSString *actual, *expected;
    actual = calculator.result, expected = @"17";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) testSubtractionNegativeResult {
    [calculator digitPressed:@"6"];
    [calculator operationPressed:@"-"];
    [calculator digitPressed:@"2"];
    [calculator digitPressed:@"4"];
    [calculator resultPressed];
    NSString *actual, *expected;
    actual = calculator.result, expected = @"-18";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

@end
