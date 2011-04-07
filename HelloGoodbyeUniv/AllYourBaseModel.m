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
@synthesize resultDigits = _resultDigits;
@synthesize secondaryDisplay = _previousDisplay;
@synthesize mainDisplay = _currentDisplay;

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
        self.mainDisplay = [NSString stringWithFormat:@"= %@", self.resultDigits];
        return; // early return if in erroneous state
    }
    
    NSString *first = @"";
    NSString *operation = @"";
    NSString *second = @"";

    if (self.currentOperation) {
        first = self.previousDigits.signedDigits;
        operation = [NSString stringWithFormat:@" %@ ", self.currentOperation];
        second = self.currentDigits.signedDigits;  
    } else {
        second = self.currentDigits.signedDigits;
    }

    NSString *oldDisplay = self.mainDisplay;
    NSString *newDisplay = [NSString stringWithFormat:
                            @"%@%@%@%@"
                            , self.previousOperation ? @"= " : @""
                            , first ? first : @""
                            , operation
                            , second ? second : @""
                            ];
    if (![oldDisplay isEqualToString:newDisplay]) {
        self.mainDisplay = newDisplay;
    }
}

- (void)updatePreviousDisplay
{
    if (self.error) {
        self.secondaryDisplay = self.previousExpression;
        return; // early return if in erroneous state
    }

    NSString *value = @"";
    
    if (self.previousOperation) {
        value = self.previousExpression;
    } else {
        value = nil;
    }
    
    NSString *oldDisplay = self.secondaryDisplay;
    NSString *newDisplay = [NSString stringWithFormat:
                            @"%@"
                            , value ? value : @""
                            ];
    
    if (![oldDisplay isEqualToString:newDisplay]) {
        self.secondaryDisplay = newDisplay;
    }
}

- (void)updateDisplays
{
    [self updatePreviousDisplay];
    [self updateCurrentDisplay];
}

- (void)performPendingOperation
{
    Digits *resultDigits;
    BOOL knownOperation = YES;
    
    if ([self.currentOperation isEqualToString:@"+"]) {
        resultDigits = [self.previousDigits plus:self.currentDigits];
    } else if ([self.currentOperation isEqualToString:@"-"]) {
        resultDigits = [self.previousDigits minus:self.currentDigits];
    } else if ([self.currentOperation isEqualToString:@"×"]) {
        resultDigits = [self.previousDigits times:self.currentDigits];
    } else if ([self.currentOperation isEqualToString:@"÷"]) {
        resultDigits = [self.previousDigits divide:self.currentDigits];
    } else if ([self.currentOperation isEqualToString:@"^"]) {
        resultDigits = [self.previousDigits power:self.currentDigits];
    } else {
        knownOperation = NO;
    }
    
    if (knownOperation) {
        if (isnan([resultDigits.value doubleValue])) {
            self.resultDigits.unsignedDigits = @"(undefined)";
            self.error = YES;
        } else if (isinf([resultDigits.value doubleValue])) {
            self.resultDigits.unsignedDigits = @"(infinity)";
            self.error = YES;
        } else {
            self.resultDigits = resultDigits;
        }
        self.previousExpression = [NSString stringWithFormat:@"%g %@ %g"
                                   , [self.previousDigits.value doubleValue]
                                   , self.currentOperation
                                   , [self.currentDigits.value doubleValue]
                                   ];
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

- (void)binaryOperationPressed:(NSString *)operation
{
    if (self.error) {
        return; // do nothing if in erroneous state
    }
    
    if (!self.currentDigits.unsignedDigits) {
        return; // do nothing if no 2nd operand has been input
    }
    
    if (self.currentOperation) {
        [self performPendingOperation];
        self.previousDigits = self.resultDigits;
    } else { // no pending operation
        self.previousDigits = self.currentDigits;
    }
    
    self.currentOperation = operation;
    self.currentDigits = [[[Digits alloc] init] autorelease];
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
        self.currentDigits = self.resultDigits;
    } else {
        self.previousExpression = self.currentDigits.signedDigits;
        self.resultDigits = self.currentDigits;
        self.previousOperation = @"=";
        self.currentOperation = nil;
    }
    self.previousDigits = [[[Digits alloc] init] autorelease];
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
    
    NSString *originalDigits = self.currentDigits.signedDigits;
    NSString *poppedDigit = [self.currentDigits popDigit];
    NSLog(@"popped digit '%@' from digits '%@'", poppedDigit, originalDigits);
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
    self.previousDigits = [[[Digits alloc] init] autorelease];
    self.currentDigits = [[[Digits alloc] init] autorelease];
    self.resultDigits = [[[Digits alloc] init] autorelease];
    self.secondaryDisplay = nil;
    self.mainDisplay = nil;
    self.currentOperation = nil;
    self.previousOperation = nil;
    self.previousExpression = nil;
    self.error = NO;
    [self updateDisplays];
}

- (void)releaseMembers
{
    self.previousDigits = nil;
    self.currentDigits = nil;
    self.resultDigits = nil;
    self.secondaryDisplay = nil;
    self.mainDisplay = nil;
    self.currentOperation = nil;
    self.previousOperation = nil;
    self.previousExpression = nil;
}

- (void)dealloc
{
    [self releaseMembers];
    [super dealloc];
}

@end