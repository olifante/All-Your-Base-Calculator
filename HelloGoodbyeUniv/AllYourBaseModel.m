//
//  AllYourBaseModel.m
//  AllYourBase
//
//  Created by Tiago Henriques on 3/29/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseModel.h"


@implementation AllYourBaseModel

@synthesize firstOperand = _firstOperand;
@synthesize secondOperand = _secondOperand;
@synthesize currentOperand = _currentOperand;
@synthesize pendingOperation = _pendingOperation;
@synthesize performedOperation = _performedOperation;
@synthesize performedExpression = _performedExpression;
@synthesize result = _result;
@synthesize firstDisplay = _firstDisplay;
@synthesize secondDisplay = _secondDisplay;

- (void)updateSecondDisplay
{
    NSString *prefix = @"";
    NSString *postfix = @"";
    NSString *displayValue = @"";
    if (self.performedOperation) {
        displayValue = self.result;
        if (!self.pendingOperation) {
            prefix = @"= ";
        }
    } else {
        displayValue = self.currentOperand;
    }
    if (self.pendingOperation) {
        postfix = [NSString stringWithFormat:@" %@", self.pendingOperation];
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
    if (self.performedOperation) {
        displayValue = self.performedExpression;
    } else {
        displayValue = self.currentOperand;
    }
    if (self.pendingOperation) {
        postfix = [NSString stringWithFormat:@" %@", self.pendingOperation];
    }
    self.secondDisplay = [NSString stringWithFormat:
                          @"%@%@%@"
                          , prefix
                          , displayValue
                          , postfix
                          ];        
}

- (double)firstOperandValue
{
    return [self.firstOperand doubleValue];
}

- (double)secondOperandValue
{
    return [self.secondOperand doubleValue];
}

- (void)performPendingOperation
{
    double resultValue;
    BOOL knownOperation = YES;
    if ([self.pendingOperation isEqualToString:@"+"]) {
        resultValue = self.firstOperandValue + self.secondOperandValue;
    } else if ([self.pendingOperation isEqualToString:@"-"]) {
        resultValue = self.firstOperandValue - self.secondOperandValue;
    } else if ([self.pendingOperation isEqualToString:@"*"]) {
        resultValue = self.firstOperandValue * self.secondOperandValue;
    } else if ([self.pendingOperation isEqualToString:@"/"]) {
        resultValue = self.firstOperandValue / self.secondOperandValue;
    } else {
        knownOperation = NO;
    }
    if (knownOperation) {
        self.result = [NSString stringWithFormat:@"%g", resultValue];
        self.performedExpression = [NSString stringWithFormat:@"%g %@ %g", self.firstOperandValue, self.pendingOperation, self.secondOperandValue];
        self.performedOperation = self.pendingOperation;
        self.pendingOperation = nil;
        self.firstOperand = nil;
        self.secondOperand = nil;
    }
}

- (void)digitPressed:(NSString *)digit
{
    if (self.currentOperand) {
        self.currentOperand = [self.currentOperand stringByAppendingString:digit];
    } else if ([digit isEqualToString:@"0"]) {
        // do not add a zero if there are no current digits
    } else if (!self.currentOperand && [digit isEqualToString:@"."]) {
        self.currentOperand = @"0."; // keep initial zero if period pressed
    } else {
        self.currentOperand = digit;
    }
    self.performedOperation = nil;
}

- (void)periodPressed
{
    unichar period = [@"." characterAtIndex:0];
    for (int i = 0; i < self.currentOperand.length; i++) {
        if ([self.currentOperand characterAtIndex:i] == period) {
            return; // do nothing if current string contains period
        }
    }
    return [self digitPressed:@"."];
}

- (void)operationPressed:(NSString *)operation
{
    if (self.pendingOperation) {
        self.secondOperand = self.currentOperand;
        [self performPendingOperation];
        self.pendingOperation = operation;
    } else { // no pending operation
        self.pendingOperation = operation;
        self.firstOperand = self.currentOperand;
        self.secondOperand = nil;
        self.currentOperand = nil;
    }
}

- (void)resultPressed
{
    if (self.pendingOperation) {
        self.secondOperand = self.currentOperand;
        [self performPendingOperation];
    } else {
        self.result = [NSString stringWithFormat:@"%g", self.firstOperandValue];
        self.performedExpression = [NSString stringWithFormat:@"%@ =", self.firstOperand ? self.firstOperand : @"0"];
        self.performedOperation = @"=";
        self.pendingOperation = nil;
        self.firstOperand = nil;
        self.secondOperand = nil;
    }
}

- (void)releaseMembers
{
    self.firstDisplay = nil;
    self.secondDisplay = nil;
    self.firstOperand = nil;
    self.secondOperand = nil;
    self.currentOperand = nil;
    self.pendingOperation = nil;
    self.performedOperation = nil;
    self.performedExpression = nil;
    self.result = nil;
}

- (void)dealloc
{
    [self releaseMembers];
    [super dealloc];
}

@end