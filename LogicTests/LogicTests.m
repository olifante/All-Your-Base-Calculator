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
    NSString *actual, *expected;
    
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
    
    actual = calculator.previousDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1 {
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
    
    actual = calculator.previousDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1Plus {
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
    
    actual = calculator.previousDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"1 + ";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1Plus2 {
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
    
    actual = calculator.previousDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"1 + 2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);    
}

- (void) test1Plus2Times {
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
    
    actual = calculator.previousDisplay, expected = @"1 + 2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"= 3 * ";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);    
}

- (void) test1Plus2Times4 {
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
    
    actual = calculator.previousDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
        
    actual = calculator.currentDisplay, expected = @"3 * 4";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);    
}

- (void) test1Plus2ResultPoint {
    [calculator digitPressed:@"1"];
    [calculator operationPressed:@"+"];
    [calculator digitPressed:@"2"];
    [calculator resultPressed];
    [calculator periodPressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression, expected = @"1 + 2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.result, expected = @"3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test4Divide3ResultPoint {
    [calculator digitPressed:@"4"];
    [calculator operationPressed:@"/"];
    [calculator digitPressed:@"3"];
    [calculator resultPressed];
    [calculator periodPressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression, expected = @"4 / 3";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.result, expected = @"1.33333";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"0.";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1Result {
    [calculator digitPressed:@"1"];
    [calculator resultPressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation, expected = @"=";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.result, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousDisplay, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"= 1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test0Result {
    [calculator digitPressed:@"0"];
    [calculator resultPressed];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation, expected = @"=";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.result, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousDisplay, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"= 0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1Result2 {
    [calculator digitPressed:@"1"];
    [calculator resultPressed];
    [calculator digitPressed:@"2"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits, expected = @"2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
        
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.result, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);    
}

- (void) test1Result2Times {
    [calculator digitPressed:@"1"];
    [calculator resultPressed];
    [calculator digitPressed:@"2"];
    [calculator operationPressed:@"*"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits, expected = @"2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentOperation, expected = @"*";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.result, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"2 * ";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1Result2Times4 {
    [calculator digitPressed:@"1"];
    [calculator resultPressed];
    [calculator digitPressed:@"2"];
    [calculator operationPressed:@"*"];
    [calculator digitPressed:@"4"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits, expected = @"2";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits, expected = @"4";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"*";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.result, expected = @"1";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"2 * 4";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test12Point34 {
    [calculator digitPressed:@"1"];
    [calculator digitPressed:@"2"];
    [calculator periodPressed];
    [calculator digitPressed:@"3"];
    [calculator digitPressed:@"4"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits, expected = @"12.34";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.result;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"12.34";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test12Point34Divide {
    [calculator digitPressed:@"1"];
    [calculator digitPressed:@"2"];
    [calculator periodPressed];
    [calculator digitPressed:@"3"];
    [calculator digitPressed:@"4"];
    [calculator operationPressed:@"/"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits, expected = @"12.34";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentOperation, expected = @"/";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.result;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"12.34 / ";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test12Point34Divide56Point78 {
    [calculator digitPressed:@"1"];
    [calculator digitPressed:@"2"];
    [calculator periodPressed];
    [calculator digitPressed:@"3"];
    [calculator digitPressed:@"4"];
    [calculator operationPressed:@"/"];
    [calculator digitPressed:@"5"];
    [calculator digitPressed:@"6"];
    [calculator periodPressed];
    [calculator digitPressed:@"7"];
    [calculator digitPressed:@"8"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits, expected = @"12.34";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits, expected = @"56.78";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"/";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.result;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"12.34 / 56.78";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);    
}

- (void) test12Point34Divide56Point78Times {
    [calculator digitPressed:@"1"];
    [calculator digitPressed:@"2"];
    [calculator periodPressed];
    [calculator digitPressed:@"3"];
    [calculator digitPressed:@"4"];
    [calculator operationPressed:@"/"];
    [calculator digitPressed:@"5"];
    [calculator digitPressed:@"6"];
    [calculator periodPressed];
    [calculator digitPressed:@"7"];
    [calculator digitPressed:@"8"];
    [calculator operationPressed:@"*"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits, expected = @"0.21733";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentOperation, expected = @"*";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation, expected = @"/";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"12.34 / 56.78";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.result, expected = @"0.21733";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousDisplay, expected = @"12.34 / 56.78";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"= 0.21733 * ";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);    
}

- (void) test12Point34Divide56Point78Times9 {
    [calculator digitPressed:@"1"];
    [calculator digitPressed:@"2"];
    [calculator periodPressed];
    [calculator digitPressed:@"3"];
    [calculator digitPressed:@"4"];
    [calculator operationPressed:@"/"];
    [calculator digitPressed:@"5"];
    [calculator digitPressed:@"6"];
    [calculator periodPressed];
    [calculator digitPressed:@"7"];
    [calculator digitPressed:@"8"];
    [calculator operationPressed:@"*"];
    [calculator digitPressed:@"9"];
    
    NSString *actual, *expected;
    
    actual = calculator.previousDigits, expected = @"0.21733";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits, expected = @"9";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"*";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression, expected = @"12.34 / 56.78";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.result, expected = @"0.21733";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"0.21733 * 9";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
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

- (void) test0Divide {
    [calculator digitPressed:@"0"];
    [calculator operationPressed:@"/"];
    NSString *actual, *expected;
    
    actual = calculator.previousDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentOperation, expected = @"/";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.result;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"0 / ";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test0Divide0 {
    [calculator digitPressed:@"0"];
    [calculator operationPressed:@"/"];
    [calculator digitPressed:@"0"];
    NSString *actual, *expected;
    
    actual = calculator.previousDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits, expected = @"0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation, expected = @"/";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousExpression;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.result;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousDisplay, expected = @"";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"0 / 0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test0Divide0Result {
    [calculator digitPressed:@"0"];
    [calculator operationPressed:@"/"];
    [calculator digitPressed:@"0"];
    [calculator resultPressed];
    NSString *actual, *expected;
    
    actual = calculator.previousDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits, expected = @"(undefined)";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation, expected = @"/";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"0 / 0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.result, expected = @"(undefined)";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousDisplay, expected = @"0 / 0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"= (undefined)";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test0Divide0Plus {
    [calculator digitPressed:@"0"];
    [calculator operationPressed:@"/"];
    [calculator digitPressed:@"0"];
    [calculator operationPressed:@"+"];
    NSString *actual, *expected;
    
    actual = calculator.previousDigits, expected = @"(undefined)";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation, expected = @"/";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"0 / 0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.result, expected = @"(undefined)";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousDisplay, expected = @"0 / 0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"= (undefined)";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

- (void) test1Divide0Result {
    [calculator digitPressed:@"1"];
    [calculator operationPressed:@"/"];
    [calculator digitPressed:@"0"];
    [calculator resultPressed];
    NSString *actual, *expected;
    
    actual = calculator.previousDigits;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.currentDigits, expected = @"(infinity)";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentOperation;
    STAssertNil(actual, @"'%@' shoud be nil", actual);
    
    actual = calculator.previousOperation, expected = @"/";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousExpression, expected = @"1 / 0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.result, expected = @"(infinity)";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.previousDisplay, expected = @"1 / 0";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
    
    actual = calculator.currentDisplay, expected = @"= (infinity)";
    STAssertTrue([actual isEqualToString:expected], @"'%@' should be equal to '%@'", actual, expected);
}

@end
