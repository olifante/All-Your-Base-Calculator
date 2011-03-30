//
//  AllYourBaseModel.m
//  AllYourBase
//
//  Created by Tiago Henriques on 3/29/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseModel.h"


@implementation AllYourBaseModel

@synthesize pendingOperation = _pendingOperation;
@synthesize currentDigits = _currentDigits;
@synthesize previousDigits = _previousDigits;
@synthesize currentDisplay;
@synthesize previousDisplay;
@synthesize operationHasJustBeenPerformed = _operationHasJustBeenPerformed;

- (void)setCurrentDigits:(NSString *)digits
{
    [_currentDigits release];
    _currentDigits = digits;
    [_currentDigits retain];
    [self updateDisplays];
}

- (void)setPreviousDigits:(NSString *)digits
{
    [_previousDigits release];
    _previousDigits = digits;
    [_previousDigits retain];
    [self updateDisplays];
}

- (void)setPendingOperation:(NSString *)pendingOperation
{
    [_pendingOperation release];
    _pendingOperation = pendingOperation;
    [_pendingOperation retain];
    [self updateDisplays];
}

- (double)currentOperand
{
    return [self.currentDigits doubleValue];
}

- (double)previousOperand
{
    return [self.previousDigits doubleValue];
}

- (void)updateDisplays
{
    [self updateCurrentDisplay];
    [self updatePreviousDisplay];
}

- (void)updatePreviousDisplay
{
    if (self.operationHasJustBeenPerformed && self.previousDigits && self.pendingOperation) {
        self.previousDisplay = [NSString stringWithFormat:
                                   @"= %@ %@"
                                   , self.previousDigits
                                   , self.pendingOperation
                                   ];
    } else if (self.operationHasJustBeenPerformed && self.previousDigits && !self.pendingOperation) {
        self.previousDisplay = [NSString stringWithFormat:
                                   @"= %@"                           
                                   , self.previousDigits
                                   ];
    } else if (!self.operationHasJustBeenPerformed && self.previousDigits && self.pendingOperation) {
        self.previousDisplay = [NSString stringWithFormat:
                                   @"%@ %@"
                                   , self.previousDigits
                                   , self.pendingOperation
                                   ];
    } else {
        self.previousDisplay = nil;
    }
}

- (void)updateCurrentDisplay
{
    if (self.currentDigits) {
        self.currentDisplay = self.currentDigits;
    } else {
        self.currentDisplay = @"0";
    }
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