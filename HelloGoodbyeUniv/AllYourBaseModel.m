//
//  AllYourBaseModel.m
//  AllYourBase
//
//  Created by Tiago Henriques on 3/29/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseModel.h"


@implementation AllYourBaseModel

@synthesize error = _error;
@synthesize previousDigits = _previousDigits;
@synthesize currentDigits = _currentDigits;
@synthesize previousNegative = _previousNegative;
@synthesize currentNegative = _currentNegative;
@synthesize currentOperation = _currentOperation;
@synthesize previousOperation = _previousOperation;
@synthesize previousExpression = _previousExpression;
@synthesize result = _result;
@synthesize previousDisplay = _previousDisplay;
@synthesize currentDisplay = _currentDisplay;

- (id)init
{
    self = [super init];
    if (self) {
        self.error = NO;
        self.previousNegative = NO;
        self.currentNegative = NO;
        [self updateDisplays];
    }
    return self;
}

- (void)updateCurrentDisplay
{
    if (self.error) {
        self.currentDisplay = [NSString stringWithFormat:@"= %@", self.result];
        return; // early return if in erroneous state
    }
    
    NSString *prefix = self.previousOperation ? @"= " : @"";
    NSString *firstSign = self.previousNegative ? @"-" : @"";
    NSString *first = @"";
    NSString *operation = @"";
    NSString *secondSign = self.currentNegative ? @"-" : @"";
    NSString *second = @"";

    if (self.currentOperation) {
        first = self.previousDigits;
        operation = [NSString stringWithFormat:@" %@ ", self.currentOperation];
        second = self.currentDigits;  
    } else {
        second = self.currentDigits ? self.currentDigits : @"0";
    }

    NSString *oldDisplay = self.currentDisplay;
    NSString *newDisplay = [NSString stringWithFormat:
                            @"%@%@%@%@"
                            , prefix
                            , first ? first : @""
                            , operation
                            , second ? second : @""
                            ];
    if (![oldDisplay isEqualToString:newDisplay]) {
        self.currentDisplay = newDisplay;
    }
}

- (void)updatePreviousDisplay
{
    if (self.error) {
        self.previousDisplay = self.previousExpression;
        return; // early return if in erroneous state
    }

    NSString *prefix = @"";
    NSString *postfix = @"";
    NSString *value = @"";
    
    if (self.previousOperation) {
        value = self.previousExpression;
    } else {
        value = nil;
    }
    
    NSString *oldDisplay = self.previousDisplay;
    NSString *newDisplay = [NSString stringWithFormat:
                            @"%@%@%@"
                            , prefix
                            , value ? value : @""
                            , postfix
                            ];
    
    if (![oldDisplay isEqualToString:newDisplay]) {
        self.previousDisplay = newDisplay;
    }
}

- (void)updateDisplays
{
    [self updatePreviousDisplay];
    [self updateCurrentDisplay];
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
    } else if ([self.currentOperation isEqualToString:@"×"]) {
        resultValue = self.previousValue * self.currentValue;
    } else if ([self.currentOperation isEqualToString:@"÷"]) {
        resultValue = self.previousValue / self.currentValue;
    } else if ([self.currentOperation isEqualToString:@"^"]) {
        resultValue = pow(self.previousValue, self.currentValue);
//        resultValue = self.previousValue something self.currentValue;
//    } else if ([self.currentOperation isEqualToString:@" ±=∙∁∶∷∞≈≪≫≝⩪⩫␡↤⇄"]) {
//        resultValue = self.previousValue something self.currentValue;
//    } else if ([self.currentOperation isEqualToString:@"√"]) {
//        resultValue = self.previousValue something self.currentValue;
//    } else if ([self.currentOperation isEqualToString:@"√"]) {
//        resultValue = self.previousValue something self.currentValue;
    } else {
        knownOperation = NO;
    }
    
    if (knownOperation) {
        if (isnan(resultValue)) {
            self.result = @"(undefined)";
            self.error = YES;
        } else if (isinf(resultValue)) {
            self.result = @"(infinity)";
            self.error = YES;
        } else {
            self.result = [NSString stringWithFormat:@"%g", resultValue];
        }
        self.previousExpression = [NSString stringWithFormat:@"%g %@ %g", self.previousValue, self.currentOperation, self.currentValue];
        self.previousOperation = self.currentOperation;
        self.currentOperation = nil;
    }
}

- (void)digitPressed:(NSString *)digit
{
    if (self.error) {
        [self releaseMembers];
    }
    
    if (self.previousOperation) {
        self.currentDigits = nil;
    }
    
    if ([self.currentDigits isEqualToString:@"0"]) {
        if ([digit isEqualToString:@"0"]) {
            self.currentDigits = @"0";            
        } else {
            self.currentDigits = digit;
        }
    } else if (self.currentDigits) {
        self.currentDigits = [self.currentDigits stringByAppendingString:digit];
    } else if (!self.currentDigits && [digit isEqualToString:@"."]) {
        self.currentDigits = @"0."; // keep initial zero if period pressed
    } else {
        self.currentDigits = digit;
    }
    
    self.previousOperation = nil;
    [self updateDisplays];
}

- (void)periodPressed
{
    if (self.previousOperation) {
        return [self digitPressed:@"."];        
    } else {
        unichar period = [@"." characterAtIndex:0];
        for (int i = 0; i < self.currentDigits.length; i++) {
            if ([self.currentDigits characterAtIndex:i] == period) {
                return; // do nothing if current string contains period
            }
        }
        return [self digitPressed:@"."];
    }
}

- (void)binaryOperationPressed:(NSString *)operation
{
    if (self.error) {
        return; // do nothing if in erroneous state
    }
    
    if (!self.currentDigits) {
        return; // do nothing if no 2nd operand has been input
    }
    
    if (self.currentOperation) {
        [self performPendingOperation];
        self.previousDigits = self.result;
    } else { // no pending operation
        self.previousDigits = self.currentDigits ? self.currentDigits : @"0";
    }
    
    self.currentOperation = operation;
    self.currentDigits = nil;
    [self updateDisplays];
}

- (void)resultPressed
{
    if (self.error) {
        return; // do nothing if in erroneous state
    }
    
    if (!self.currentDigits) {
        return; // do nothing if no 2nd operand has been input
    }

    if (self.currentOperation) {
        [self performPendingOperation];
        self.currentDigits = self.result;
    } else {
        self.previousExpression = [NSString stringWithFormat:@"%@", self.currentDigits ? self.currentDigits : @"0"];
        self.result = [NSString stringWithFormat:@"%g", self.currentValue];
        self.currentDigits = self.result;
        self.previousOperation = @"=";
        self.currentOperation = nil;
    }
    self.previousDigits = nil;
    [self updateDisplays];
}

- (void)deletePressed
{
    if (self.error) {
        [self releaseMembers];
        return; // clean up and do nothing if in erroneous state
    }
    
    if (self.previousOperation) {
        return; // do not allow results of previous operation to be modified
    }
    
    NSString *newDigits;
    if (self.currentDigits) {
        if ([self.currentDigits length] > 1) {
            newDigits = [self.currentDigits substringToIndex:([self.currentDigits length] - 1)];
        } else if ([self.currentDigits isEqualToString:@"0"]) {
            newDigits = @"0";
        } else {
            newDigits = nil;
        }
        
        self.currentDigits = newDigits;
        [self updateDisplays];
    }
}

- (void)negatePressed
{
    
}

- (void)shiftLeftPressed
{
    
}

- (void)shiftRightPressed
{
    
}

- (void)percentPressed
{
    
}

- (void)EEPressed
{
    
}

- (void)releaseMembers
{
    self.previousDisplay = nil;
    self.currentDisplay = nil;
    self.previousDigits = nil;
    self.currentDigits = nil;
    self.currentOperation = nil;
    self.previousOperation = nil;
    self.previousExpression = nil;
    self.result = nil;
    self.error = NO;
    self.previousNegative = NO;
    self.currentNegative = NO;
    [self updateDisplays];
}

- (void)dealloc
{
    [self releaseMembers];
    [super dealloc];
}

@end