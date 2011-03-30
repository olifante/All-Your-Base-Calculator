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