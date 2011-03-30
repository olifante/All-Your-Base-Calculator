//
//  AllYourBaseModel.m
//  AllYourBase
//
//  Created by Tiago Henriques on 3/29/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseModel.h"


@implementation AllYourBaseModel

@synthesize operationHasJustBeenPerformed = _operationHasJustBeenPerformed;
@synthesize pendingOperation = _pendingOperation;
@synthesize currentDigits = _currentDigits;
@synthesize previousDigits = _previousDigits;

- (NSString *)currentDisplay
{
    NSString *returnValue;
    if (self.currentDigits) {
        returnValue = self.currentDigits;
    } else {
        returnValue = @"0";
    }
    return returnValue;
}

- (NSString *)previousDisplay
{
    NSString *returnValue;
    NSString *prefix = @"";
    NSString *postfix = @"";
    if (self.operationHasJustBeenPerformed) {
        prefix = @"= ";
    }
    if (self.pendingOperation) {
        postfix = [NSString stringWithFormat:@" %@", self.pendingOperation];
    }
    if (self.previousDigits) {
        returnValue = [NSString stringWithFormat:
                       @"%@%@%@"
                       , prefix
                       , self.previousDigits
                       , postfix
                       ];        
    } else {
        returnValue = nil;
    }
    return returnValue;
//    return previousDigits;
}

- (double)currentOperand
{
    return [self.currentDigits doubleValue];
}

- (double)previousOperand
{
    return [self.previousDigits doubleValue];
}

- (void)digitPressed:(NSString *)digit
{
    if (!self.pendingOperation && self.previousDigits) {
        [self releaseMembers]; // if there is no pending operation we don't want stale values lying around
    }
    if (self.currentDigits) {
        self.currentDigits = [self.currentDigits stringByAppendingString:digit];
    } else if ([digit isEqualToString:@"0"]) {
        // do not add a zero if there are no current digits
    } else if (!self.currentDigits && [digit isEqualToString:@"."]) {
        self.currentDigits = @"0."; // keep initial zero if period pressed
    } else {
        self.currentDigits = digit;
    }
    self.operationHasJustBeenPerformed = NO;
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
    if (!self.currentDigits && self.pendingOperation) {
        // do nothing if 2nd operation pressed with an empty 2nd operand
    } else if (self.pendingOperation) {
        [self performPendingOperation];
        self.pendingOperation = operation;
    } else { // no pending operation
        if (!self.operationHasJustBeenPerformed) {
            // if no operation has just been performed, the 1st operand is empty
            self.previousDigits = self.currentDigits;
        }
        self.pendingOperation = operation;
        self.currentDigits = nil;
    }
}

- (void)resultPressed
{
    if (self.currentDigits && self.pendingOperation) {
        [self performPendingOperation];
    } else if (self.pendingOperation) { // but no 2nd operand
        self.pendingOperation = nil;
    } else if (self.previousDigits) {
        self.previousDigits = [NSString stringWithFormat:@"%g", self.previousOperand];
    } else {
        self.previousDigits = [NSString stringWithFormat:@"%g", self.currentOperand];
    }
    self.currentDigits = nil;
    self.operationHasJustBeenPerformed = YES;
}

- (void)releaseMembers
{
    self.pendingOperation = nil;
    self.previousDigits = nil;
    self.currentDigits = nil;
    self.operationHasJustBeenPerformed = NO;
}

- (void)dealloc
{
    [self releaseMembers];
    [super dealloc];
}

- (void)performPendingOperation
{
    double result;
    BOOL success = YES;
    if ([self.pendingOperation isEqualToString:@"+"]) {
        result = self.previousOperand + self.currentOperand;
    } else if ([self.pendingOperation isEqualToString:@"-"]) {
        result = self.previousOperand - self.currentOperand;
    } else if ([self.pendingOperation isEqualToString:@"*"]) {
        result = self.previousOperand * self.currentOperand;
    } else if ([self.pendingOperation isEqualToString:@"/"]) {
        result = self.previousOperand / self.currentOperand;
    } else {
        success = NO;
    }
    if (success) {
        self.previousDigits = [NSString stringWithFormat:@"%g", result];
        self.pendingOperation = nil;
        self.currentDigits = nil;
        self.operationHasJustBeenPerformed = YES;
    }
}

@end