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
    [calculator binaryOperationPressed:@"+"];
    [calculator digitPressed:@"2"];
    [calculator resultPressed];
    NSString *actual, *expected;

    actual = calculator.resultDigits.description, expected = @"8";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) testDivision {
    [calculator digitPressed:@"1"];
    [calculator digitPressed:@"9"];
    [calculator binaryOperationPressed:@"÷"];
    [calculator digitPressed:@"8"];
    [calculator resultPressed];
    NSString *actual, *expected;
    
    actual = calculator.resultDigits.description, expected = @"2.375";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) testInit {
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1Plus2TimesClean {
    [calculator digitPressed:@"1"];
    [calculator binaryOperationPressed:@"+"];
    [calculator digitPressed:@"2"];
    [calculator binaryOperationPressed:@"*"];
    [calculator cleanPressed];

    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1 {
    [calculator digitPressed:@"1"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test0 {
    [calculator digitPressed:@"0"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test00 {
    [calculator digitPressed:@"0"];
    [calculator digitPressed:@"0"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test01 {
    [calculator digitPressed:@"0"];
    [calculator digitPressed:@"1"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1Plus {
    [calculator digitPressed:@"1"];
    [calculator binaryOperationPressed:@"+"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"+";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"1 + ";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1PlusResult {
    [calculator digitPressed:@"1"];
    [calculator binaryOperationPressed:@"+"];
    [calculator resultPressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"+";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"1 + ";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1PlusTimes {
    [calculator digitPressed:@"1"];
    [calculator binaryOperationPressed:@"+"];
    [calculator binaryOperationPressed:@"*"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"+";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"1 + ";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1Plus2 {
    [calculator digitPressed:@"1"];
    [calculator binaryOperationPressed:@"+"];
    [calculator digitPressed:@"2"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits.description, expected = @"2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"+";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"1 + 2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);    
}

- (void) test1Plus2Times {
    [calculator digitPressed:@"1"];
    [calculator binaryOperationPressed:@"+"];
    [calculator digitPressed:@"2"];
    [calculator binaryOperationPressed:@"*"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description, expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"*";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation, expected = @"+";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"1 + 2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"1 + 2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"= 3 * ";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);    
}

- (void) test1Plus2Times4 {
    [calculator digitPressed:@"1"];
    [calculator binaryOperationPressed:@"+"];
    [calculator digitPressed:@"2"];
    [calculator binaryOperationPressed:@"*"];
    [calculator digitPressed:@"4"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description, expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits.description, expected = @"4";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"*";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression, expected = @"1 + 2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
        
    actual = calculator.mainDisplay, expected = @"3 * 4";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);    
}

- (void) test1Plus2Result {
    [calculator digitPressed:@"1"];
    [calculator binaryOperationPressed:@"+"];
    [calculator digitPressed:@"2"];
    [calculator resultPressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation, expected = @"+";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"1 + 2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"1 + 2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"= 3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1Plus2ResultNegate {
    [calculator digitPressed:@"1"];
    [calculator binaryOperationPressed:@"+"];
    [calculator digitPressed:@"2"];
    [calculator resultPressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation, expected = @"+";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"1 + 2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"1 + 2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"= 3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1Plus2ResultDelete {
    [calculator digitPressed:@"1"];
    [calculator binaryOperationPressed:@"+"];
    [calculator digitPressed:@"2"];
    [calculator resultPressed];
    [calculator deletePressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation, expected = @"+";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"1 + 2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"1 + 2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"= 3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1Plus2ResultPoint {
    [calculator digitPressed:@"1"];
    [calculator binaryOperationPressed:@"+"];
    [calculator digitPressed:@"2"];
    [calculator resultPressed];
    [calculator digitPressed:@"."];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression, expected = @"1 + 2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test4Divide3ResultPoint {
    [calculator digitPressed:@"4"];
    [calculator binaryOperationPressed:@"÷"];
    [calculator digitPressed:@"3"];
    [calculator resultPressed];
    [calculator digitPressed:@"."];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression, expected = @"4 ÷ 3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"1.33333";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) testResult {
    [calculator resultPressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation, expected = @"=";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"= 0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) testNegateResult {
    [calculator negatePressed];
    [calculator resultPressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation, expected = @"=";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"= 0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test0Result {
    [calculator digitPressed:@"0"];
    [calculator resultPressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation, expected = @"=";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"= 0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1Result {
    [calculator digitPressed:@"1"];
    [calculator resultPressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation, expected = @"=";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"= 1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1NegateResult {
    [calculator digitPressed:@"1"];
    [calculator negatePressed];
    [calculator resultPressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation, expected = @"=";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"= -1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) testNegate {
    [calculator negatePressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"-";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"-";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) testNegate1 {
    [calculator negatePressed];
    [calculator digitPressed:@"1"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1Negate {
    [calculator digitPressed:@"1"];
    [calculator negatePressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"-1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1ResultNegate {
    [calculator digitPressed:@"1"];
    [calculator resultPressed];
    [calculator negatePressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"-";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"-";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);}

- (void) test1Result2 {
    [calculator digitPressed:@"1"];
    [calculator resultPressed];
    [calculator digitPressed:@"2"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
        
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);    
}

- (void) test1Result2Times {
    [calculator digitPressed:@"1"];
    [calculator resultPressed];
    [calculator digitPressed:@"2"];
    [calculator binaryOperationPressed:@"*"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description, expected = @"2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"*";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"2 * ";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1Result2Times4 {
    [calculator digitPressed:@"1"];
    [calculator resultPressed];
    [calculator digitPressed:@"2"];
    [calculator binaryOperationPressed:@"*"];
    [calculator digitPressed:@"4"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description, expected = @"2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits.description, expected = @"4";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"*";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"2 * 4";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test12Point34 {
    [calculator digitPressed:@"1"];
    [calculator digitPressed:@"2"];
    [calculator digitPressed:@"."];
    [calculator digitPressed:@"3"];
    [calculator digitPressed:@"4"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"12.34";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"12.34";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test12Point345Delete {
    [calculator digitPressed:@"1"];
    [calculator digitPressed:@"2"];
    [calculator digitPressed:@"."];
    [calculator digitPressed:@"3"];
    [calculator digitPressed:@"4"];
    [calculator digitPressed:@"5"];
    [calculator deletePressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits.description, expected = @"12.34";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"12.34";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}


- (void) test12Point34Divide {
    [calculator digitPressed:@"1"];
    [calculator digitPressed:@"2"];
    [calculator digitPressed:@"."];
    [calculator digitPressed:@"3"];
    [calculator digitPressed:@"4"];
    [calculator binaryOperationPressed:@"÷"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description, expected = @"12.34";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"÷";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"12.34 ÷ ";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test12Point34Divide56Point78 {
    [calculator digitPressed:@"1"];
    [calculator digitPressed:@"2"];
    [calculator digitPressed:@"."];
    [calculator digitPressed:@"3"];
    [calculator digitPressed:@"4"];
    [calculator binaryOperationPressed:@"÷"];
    [calculator digitPressed:@"5"];
    [calculator digitPressed:@"6"];
    [calculator digitPressed:@"."];
    [calculator digitPressed:@"7"];
    [calculator digitPressed:@"8"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description, expected = @"12.34";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits.description, expected = @"56.78";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"÷";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"12.34 ÷ 56.78";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);    
}

- (void) test12Point34Divide56Point78Times {
    [calculator digitPressed:@"1"];
    [calculator digitPressed:@"2"];
    [calculator digitPressed:@"."];
    [calculator digitPressed:@"3"];
    [calculator digitPressed:@"4"];
    [calculator binaryOperationPressed:@"÷"];
    [calculator digitPressed:@"5"];
    [calculator digitPressed:@"6"];
    [calculator digitPressed:@"."];
    [calculator digitPressed:@"7"];
    [calculator digitPressed:@"8"];
    [calculator binaryOperationPressed:@"*"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description, expected = @"0.21733";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"*";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation, expected = @"÷";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"12.34 ÷ 56.78";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"0.21733";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"12.34 ÷ 56.78";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"= 0.21733 * ";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);    
}

- (void) test12Point34Divide56Point78Times9 {
    [calculator digitPressed:@"1"];
    [calculator digitPressed:@"2"];
    [calculator digitPressed:@"."];
    [calculator digitPressed:@"3"];
    [calculator digitPressed:@"4"];
    [calculator binaryOperationPressed:@"÷"];
    [calculator digitPressed:@"5"];
    [calculator digitPressed:@"6"];
    [calculator digitPressed:@"."];
    [calculator digitPressed:@"7"];
    [calculator digitPressed:@"8"];
    [calculator binaryOperationPressed:@"*"];
    [calculator digitPressed:@"9"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description, expected = @"0.21733";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits.description, expected = @"9";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"*";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression, expected = @"12.34 ÷ 56.78";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.resultDigits.description, expected = @"0.21733";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"0.21733 * 9";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) testInputException {
    NSLog(@"%@ start", self.name);
	STAssertThrows([calculator digitPressed:@"67"], @"No exception for multicharacter input.");
	STAssertThrows([calculator binaryOperationPressed:@"j"],  @"No exception for invalid input.");
	STAssertThrows([calculator digitPressed:nil],   @"No exception for nil input.");
	STAssertThrows([calculator binaryOperationPressed:nil],   @"No exception for nil input.");
    NSLog(@"%@ end", self.name);
}

- (void) testMultiplication {
    [calculator digitPressed:@"6"];
    [calculator binaryOperationPressed:@"×"];
    [calculator digitPressed:@"2"];
    [calculator resultPressed];
    NSString *actual, *expected;
    actual = calculator.resultDigits.description, expected = @"12";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) testSubtraction {
    [calculator digitPressed:@"1"];
    [calculator digitPressed:@"9"];
    [calculator binaryOperationPressed:@"-"];
    [calculator digitPressed:@"2"];
    [calculator resultPressed];
    NSString *actual, *expected;
    actual = calculator.resultDigits.description, expected = @"17";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) testSubtractionNegativeResult {
    [calculator digitPressed:@"6"];
    [calculator binaryOperationPressed:@"-"];
    [calculator digitPressed:@"2"];
    [calculator digitPressed:@"4"];
    [calculator resultPressed];
    NSString *actual, *expected;
    actual = calculator.resultDigits.description, expected = @"-18";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test0Divide {
    [calculator digitPressed:@"0"];
    [calculator binaryOperationPressed:@"÷"];
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits.description, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"÷";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"0 ÷ ";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test0Divide0 {
    [calculator digitPressed:@"0"];
    [calculator binaryOperationPressed:@"÷"];
    [calculator digitPressed:@"0"];
    NSString *actual, *expected;
    
    actual = calculator.previousDigits.description, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits.description, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"÷";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.resultDigits.description;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.secondaryDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.mainDisplay, expected = @"0 ÷ 0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

//- (void) test0Divide0Result {
//    [calculator digitPressed:@"0"];
//    [calculator binaryOperationPressed:@"÷"];
//    [calculator digitPressed:@"0"];
//    [calculator resultPressed];
//    NSString *actual, *expected;
//    
//    actual = calculator.previousDigits.description;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.currentDigits.description, expected = @"(undefined)";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.currentOperation;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.previousOperation, expected = @"÷";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.previousExpression, expected = @"0 ÷ 0";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.resultDigits.description, expected = @"(undefined)";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.secondaryDisplay, expected = @"0 ÷ 0";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.mainDisplay, expected = @"= (undefined)";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//}
//
//- (void) test0Divide0ResultPlus {
//    [calculator digitPressed:@"0"];
//    [calculator binaryOperationPressed:@"÷"];
//    [calculator digitPressed:@"0"];
//    [calculator resultPressed];
//    [calculator binaryOperationPressed:@"+"];
//    NSString *actual, *expected;
//    
//    actual = calculator.previousDigits.description;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.currentDigits.description, expected = @"(undefined)";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.currentOperation;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.previousOperation, expected = @"÷";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.previousExpression, expected = @"0 ÷ 0";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.resultDigits.description, expected = @"(undefined)";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.secondaryDisplay, expected = @"0 ÷ 0";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.mainDisplay, expected = @"= (undefined)";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//}
//
//- (void) test0Divide0Result1 {
//    [calculator digitPressed:@"0"];
//    [calculator binaryOperationPressed:@"÷"];
//    [calculator digitPressed:@"0"];
//    [calculator resultPressed];
//    [calculator binaryOperationPressed:@"+"];
//    [calculator digitPressed:@"1"];
//    
//    NSString *actual, *expected;
//    
//    actual = calculator.previousDigits.description;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.currentDigits.description, expected = @"1";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.currentOperation;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.previousOperation;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.previousExpression;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.resultDigits.description;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.secondaryDisplay, expected = @"";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.mainDisplay, expected = @"1";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//}
//
//- (void) test0Divide0Plus {
//    [calculator digitPressed:@"0"];
//    [calculator binaryOperationPressed:@"÷"];
//    [calculator digitPressed:@"0"];
//    [calculator binaryOperationPressed:@"+"];
//    NSString *actual, *expected;
//    
//    actual = calculator.previousDigits.description, expected = @"(undefined)";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.currentDigits.description;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.currentOperation, expected = @"+";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.previousOperation, expected = @"÷";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.previousExpression, expected = @"0 ÷ 0";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.resultDigits.description, expected = @"(undefined)";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.secondaryDisplay, expected = @"0 ÷ 0";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.mainDisplay, expected = @"= (undefined)";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//}
//
//- (void) test0Divide0PlusResult {
//    [calculator digitPressed:@"0"];
//    [calculator binaryOperationPressed:@"÷"];
//    [calculator digitPressed:@"0"];
//    [calculator binaryOperationPressed:@"+"];
//    [calculator resultPressed];
//    NSString *actual, *expected;
//    
//    actual = calculator.previousDigits.description, expected = @"(undefined)";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.currentDigits.description;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.currentOperation, expected = @"+";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.previousOperation, expected = @"÷";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.previousExpression, expected = @"0 ÷ 0";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.resultDigits.description, expected = @"(undefined)";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.secondaryDisplay, expected = @"0 ÷ 0";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.mainDisplay, expected = @"= (undefined)";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//}
//
//- (void) test0Divide0Plus1 {
//    [calculator digitPressed:@"0"];
//    [calculator binaryOperationPressed:@"÷"];
//    [calculator digitPressed:@"0"];
//    [calculator binaryOperationPressed:@"+"];
//    [calculator digitPressed:@"1"];
//    
//    NSString *actual, *expected;
//    
//    actual = calculator.previousDigits.description;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.currentDigits.description, expected = @"1";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.currentOperation;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.previousOperation;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.previousExpression;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.resultDigits.description;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.secondaryDisplay, expected = @"";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.mainDisplay, expected = @"1";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//}
//
//- (void) test1Divide0Result {
//    [calculator digitPressed:@"1"];
//    [calculator binaryOperationPressed:@"÷"];
//    [calculator digitPressed:@"0"];
//    [calculator resultPressed];
//    NSString *actual, *expected;
//    
//    actual = calculator.previousDigits.description;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.currentDigits.description, expected = @"(infinity)";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.currentOperation;
//    STAssertNil(actual, @"'%@' shoud be nil", actual);
//    
//    actual = calculator.previousOperation, expected = @"÷";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.previousExpression, expected = @"1 ÷ 0";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.resultDigits.description, expected = @"(infinity)";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.secondaryDisplay, expected = @"1 ÷ 0";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//    
//    actual = calculator.mainDisplay, expected = @"= (infinity)";
//    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
//}

@end
