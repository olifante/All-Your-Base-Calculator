//
//  AllYourBaseModel.m
//  AllYourBase
//
//  Created by Tiago Henriques on 3/29/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseModel.h"


@implementation AllYourBaseModel

@synthesize previousDigits = _previousDigits;
@synthesize currentDigits = _currentDigits;
@synthesize currentOperation = _currentOperation;
@synthesize previousOperation = _previousOperation;
@synthesize previousExpression = _previousExpression;
@synthesize result = _result;
@synthesize firstDisplay = _firstDisplay;
@synthesize secondDisplay = _secondDisplay;

- (void)updateSecondDisplay
{
    NSString *prefix = @"";
    NSString *postfix = @"";
    NSString *displayValue = @"";
    if (self.previousOperation) {
        displayValue = self.result;
        if (!self.currentOperation) {
            prefix = @"= ";
        }
    } else {
        displayValue = self.currentDigits;
    }
    if (self.currentOperation) {
        postfix = [NSString stringWithFormat:@" %@", self.currentOperation];
    }
    self.secondDisplay = [NSString stringWithFormat:
                            @"%@%@%@"
                            , prefix
                            , displayValue
                            , postfix
                            ];        
}

- (void)updateFirstDisplay
{
    NSString *prefix = @"";
    NSString *postfix = @"";
    NSString *displayValue = @"";
    if (self.previousOperation) {
        displayValue = self.previousExpression;
    } else {
        displayValue = self.currentDigits;
    }
    if (self.currentOperation) {
        postfix = [NSString stringWithFormat:@" %@", self.currentOperation];
    }
    self.secondDisplay = [NSString stringWithFormat:
                          @"%@%@%@"
                          , prefix
                          , displayValue
                          , postfix
                          ];        
}

- (double)previousValue
{
    return [self.previousDigits doubleValue];
}

- (double)currentValue
{
    return [self.currentDigits doubleValue];
}

- (void)performPendingOperation
{
    double resultValue;
    BOOL knownOperation = YES;
    if ([self.currentOperation isEqualToString:@"+"]) {
        resultValue = self.previousValue + self.currentValue;
    } else if ([self.currentOperation isEqualToString:@"-"]) {
        resultValue = self.previousValue - self.currentValue;
    } else if ([self.currentOperation isEqualToString:@"*"]) {
        resultValue = self.previousValue * self.currentValue;
    } else if ([self.currentOperation isEqualToString:@"/"]) {
        resultValue = self.previousValue / self.currentValue;
    } else {
        knownOperation = NO;
    }
    if (knownOperation) {
        self.result = [NSString stringWithFormat:@"%g", resultValue];
        self.previousExpression = [NSString stringWithFormat:@"%g %@ %g", self.previousValue, self.currentOperation, self.currentValue];
        self.previousOperation = self.currentOperation;
        self.currentOperation = nil;
    }
}

- (void)digitPressed:(NSString *)digit
{
    if (self.currentDigits) {
        self.currentDigits = [self.currentDigits stringByAppendingString:digit];
    } else if ([digit isEqualToString:@"0"]) {
        // do not add a zero if there are no current digits
    } else if (!self.currentDigits && [digit isEqualToString:@"."]) {
        self.currentDigits = @"0."; // keep initial zero if period pressed
    } else {
        self.currentDigits = digit;
    }
    self.previousOperation = nil;
}

- (void)periodPressed
{
    unichar period = [@"." characterAtIndex:0];
    for (int i = 0; i < self.currentDigits.length; i++) {
        if ([self.currentDigits characterAtIndex:i] == period) {
            return; // do nothing if current string contains period
        }
    }
    return [self digitPressed:@"."];
}

- (void)operationPressed:(NSString *)operation
{
    if (self.currentOperation) {
        [self performPendingOperation];
        self.previousDigits = self.result;
    } else { // no pending operation
        self.previousDigits = self.currentDigits;
    }
    self.currentOperation = operation;
    self.currentDigits = nil;
}

- (void)resultPressed
{
    if (self.currentOperation) {
        [self performPendingOperation];
    } else {
        self.result = [NSString stringWithFormat:@"%g", self.previousValue];
        self.currentDigits = self.result;
        self.previousExpression = [NSString stringWithFormat:@"%@ =", self.previousDigits ? self.previousDigits : @"0"];
        self.previousOperation = @"=";
        self.currentOperation = nil;
        self.previousDigits = nil;
    }
}

- (void)releaseMembers
{
    self.firstDisplay = nil;
    self.secondDisplay = nil;
    self.previousDigits = nil;
    self.currentDigits = nil;
    self.currentOperation = nil;
    self.previousOperation = nil;
    self.previousExpression = nil;
    self.result = nil;
}

- (void)dealloc
{
    [self releaseMembers];
    [super dealloc];
}

@end