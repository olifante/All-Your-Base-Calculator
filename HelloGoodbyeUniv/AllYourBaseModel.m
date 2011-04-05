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
        self.previousDigits = [[[Digits alloc] init] autorelease];
        self.currentDigits = [[[Digits alloc] init] autorelease];
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
    
    NSString *first = @"";
    NSString *operation = @"";
    NSString *second = @"";

    if (self.currentOperation) {
        first = self.previousDigits.text;
        operation = [NSString stringWithFormat:@" %@ ", self.currentOperation];
        second = self.currentDigits.text;  
    } else {
        second = self.currentDigits.text;
    }

    NSString *oldDisplay = self.currentDisplay;
    NSString *newDisplay = [NSString stringWithFormat:
                            @"%@%@%@%@"
                            , self.previousOperation ? @"= " : @""
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

    NSString *value = @"";
    
    if (self.previousOperation) {
        value = self.previousExpression;
    } else {
        value = nil;
    }
    
    NSString *oldDisplay = self.previousDisplay;
    NSString *newDisplay = [NSString stringWithFormat:
                            @"%@"
                            , value ? value : @""
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
    return [self.previousDigits.value doubleValue];
}

- (double)currentValue
{
    return [self.currentDigits.value doubleValue];
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
        self.currentDigits = [[[Digits alloc] init] autorelease];
    }
    
    [self.currentDigits pushDigit:digit];
    
    self.previousOperation = nil;
    [self updateDisplays];
}

- (void)periodPressed
{
    
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
        self.previousExpression = [NSString stringWithFormat:@"%@", self.currentDigits.text];
        self.result = [NSString stringWithFormat:@"%@", self.currentDigits.vale ];
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

- (void)cleanPressed
{
    self.previousDisplay = nil;
    self.currentDisplay = nil;
    self.previousDigits = [[[Digits alloc] init] autorelease];
    self.currentDigits = [[[Digits alloc] init] autorelease];
    self.currentOperation = nil;
    self.previousOperation = nil;
    self.previousExpression = nil;
    self.result = nil;
    self.error = NO;
    [self updateDisplays];
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
}

- (void)dealloc
{
    [self releaseMembers];
    [super dealloc];
}

@end