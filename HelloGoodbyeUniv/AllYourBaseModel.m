//
//  AllYourBaseModel.m
//  AllYourBase
//
//  Created by Tiago Henriques on 3/29/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseModel.h"


@implementation AllYourBaseModel

@synthesize currentDigits;
@synthesize previousDigits;
@synthesize currentOperation;
@synthesize previousOperation;
@synthesize previousExpression;
@synthesize resultDigits;
@synthesize secondaryDisplay;
@synthesize mainDisplay;
@synthesize error;

- (id)init
{
    self = [super init];
    if (self) {
        self.error = nil;
        self.previousDigits = nil;
        self.currentDigits = [[[Digits alloc] init] autorelease];
        [self updateDisplays];
    }
    return self;
}

- (void)updateMainDisplay
{
    if (self.error) {
        self.mainDisplay = [self.error localizedDescription];
        return; // early return if in erroneous state
    }

    NSString *firstOperand = @"";
    NSString *paddedOperation = @"";
    NSString *secondOperand = @"";
    
    if (self.currentOperation) {
        firstOperand = self.previousDigits.description;
        paddedOperation = [NSString stringWithFormat:@" %@ ", self.currentOperation];
        secondOperand = self.currentDigits.description;  
    } else {
        secondOperand = [self.currentDigits.description isEqualToString:@""] ? @"0" : self.currentDigits.description;
    }

    NSString *oldDisplay = self.mainDisplay;
    NSString *newDisplay = [NSString stringWithFormat:
                            @"%@%@%@%@"
                            , self.previousOperation ? @"= " : @""
                            , firstOperand ? firstOperand : @""
                            , paddedOperation
                            , secondOperand ? secondOperand : @""
                            ];
    if (![oldDisplay isEqualToString:newDisplay]) {
        self.mainDisplay = newDisplay;
    }
}

- (void)updateSecondaryDisplay
{
    if (self.error) {
        self.secondaryDisplay = self.previousExpression;
        return; // early return if in erroneous state
    }

    NSString *oldDisplay = self.secondaryDisplay;
    NSString *newDisplay = [NSString stringWithFormat:
                            @"%@"
                            , self.previousOperation ? self.previousExpression : @""
                            ];
    
    if (![oldDisplay isEqualToString:newDisplay]) {
        self.secondaryDisplay = newDisplay;
    }
}

- (void)updateDisplays
{
    [self updateSecondaryDisplay];
    [self updateMainDisplay];
}

- (void)performPendingOperationWithError:(NSError **)operationError
{
    Digits *operationResultDigits = nil;
    
    if ([self.currentOperation isEqualToString:@"+"]) {
        operationResultDigits = [self.previousDigits plus:self.currentDigits withError:operationError];
    } else if ([self.currentOperation isEqualToString:@"-"]) {
        operationResultDigits = [self.previousDigits minus:self.currentDigits withError:operationError];
    } else if ([self.currentOperation isEqualToString:@"*"]) {
        operationResultDigits = [self.previousDigits times:self.currentDigits withError:operationError];
    } else if ([self.currentOperation isEqualToString:@"/"]) {
        operationResultDigits = [self.previousDigits divide:self.currentDigits withError:operationError];
    } else if ([self.currentOperation isEqualToString:@"^"]) {
        operationResultDigits = [self.previousDigits power:self.currentDigits withError:operationError];
    } else {
        NSLog(@"unknown operation '%@'", self.currentOperation);
        if (operationError) {            
            NSDictionary *userDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedString(@"unknown opeartion", @""),
                                       NSLocalizedDescriptionKey,
                                       nil] autorelease];
            NSError *localError = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:EPERM userInfo:userDict] autorelease];
            *operationError = localError;
        }
    }
    
    self.previousExpression = [NSString stringWithFormat:@"%@ %@ %@"
                               , self.previousDigits ? self.previousDigits.description : @""
                               , self.currentOperation ? self.currentOperation : @""
                               , self.currentDigits ? self.currentDigits.description : @""
                               ];
    self.previousOperation = self.currentOperation;
    self.currentOperation = nil;        
    self.resultDigits = operationResultDigits;
}

- (void)digitPressed:(NSString *)digit
{
    if (self.error) {
        [self cleanPressed];
        NSLog(@"cleaned up after pressing digit in an erroneous state");
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
        NSLog(@"No action - operations do nothing after error");
        return;
    }
    
    if (!self.currentDigits.unsignedDigits && !self.currentOperation) {
        NSLog(@"No action - operations do nothing without a 2nd operand");
    } else if (!self.currentDigits.unsignedDigits && self.currentOperation) {
        if (self.currentDigits.positive) {
            self.currentOperation = operation;
            // pressing another operation when no 2nd operand digit or minus sign has been input cancels the pending operation
        } else {
            // pressing another operation when a minus sign has been input does nothing            
        }
    } else if (self.currentDigits.unsignedDigits && self.currentOperation) {
        NSError *operationError = nil;
        [self performPendingOperationWithError:&operationError];

        if (!self.resultDigits && operationError) {
            NSLog(@"binary operation error after chaining operation");
            self.error = operationError;
        } else {            
            self.previousDigits = self.resultDigits;
            self.currentOperation = operation;
            self.currentDigits = [[[Digits alloc] init] autorelease];
        }
    } else { // no pending operation
        self.previousDigits = self.currentDigits;
        self.currentOperation = operation;
        self.currentDigits = [[[Digits alloc] init] autorelease];
    }
    
    [self updateDisplays];
}

- (void)resultPressed
{
    if (self.error) {
        NSLog(@"No action - result does nothing after error");
        return;
    }
    
    if (self.currentOperation && self.currentDigits.unsignedDigits) {
        NSLog(@"############### path0"); // test1Plus2Result
        NSError *operationError = nil;
        [self performPendingOperationWithError:&operationError];

        if (!self.resultDigits && operationError) {
            NSLog(@"binary operation error after pressing result");
            self.error = operationError;
        } else {            
            self.currentDigits = self.resultDigits;
            self.previousDigits = nil;
            self.currentOperation = nil;
        }
    } else if (self.currentOperation && !self.currentDigits.unsignedDigits) {
        NSLog(@"No action - operation cannot be performed without a 2nd operand");
        NSLog(@"############### path1"); // test1PlusResult
    } else if (!self.currentOperation && !self.currentDigits.unsignedDigits && self.currentDigits.positive) {
        NSLog(@"############### path2"); // testResult
        self.currentDigits = [[[Digits alloc] init] autorelease];
        self.resultDigits = self.currentDigits;
        self.previousDigits = nil;
        self.currentOperation = nil;
        self.previousOperation = @"=";
        self.previousExpression = @"0";
    } else if (!self.currentOperation && !self.currentDigits.unsignedDigits && !self.currentDigits.positive) {
        NSLog(@"No action - negate is waiting for digits to be input");
        NSLog(@"############### path3"); // testNegateResult
    } else if (!self.currentOperation && self.currentDigits.unsignedDigits && self.currentDigits.positive) {
        NSLog(@"############### path4"); // test1Result
        self.resultDigits = self.currentDigits;
        self.previousDigits = nil;
        self.currentOperation = nil;
        self.previousOperation = @"=";
        self.previousExpression = self.currentDigits.description;
    } else if (!self.currentOperation && self.currentDigits.unsignedDigits && !self.currentDigits.positive) {
        NSLog(@"############### path5"); // test1NegateResult
        self.resultDigits = self.currentDigits;
        self.previousDigits = nil;
        self.currentOperation = nil;
        self.previousOperation = @"=";
        self.previousExpression = self.currentDigits.description;
    } else {
        NSLog(@"############### path6"); // no tests, this condition should not be reached
        assert(NO);
    }
    [self updateDisplays];
}

- (void)deletePressed
{
    if (self.error) {
        [self cleanPressed];
        NSLog(@"cleaned up after pressing delete in an erroneous state");
        return;
    }
    
    if (self.previousOperation) {
        NSLog(@"No action - delete does not alter calculation results");
        return;
    }
    
    NSString *originalDigits = self.currentDigits.signedDigits;
    NSString *poppedDigit = [self.currentDigits popDigit];
    NSLog(@"popped digit '%@' from digits '%@'", poppedDigit, originalDigits);
    [self updateDisplays];    
}

- (void)negatePressed
{

    if (self.error) {
        NSLog(@"No action - negate does nothing after error");
        return;
    }

    
    if (self.previousOperation) {
        self.previousOperation = nil;
        self.previousExpression = nil;  
        self.resultDigits = nil;
        self.currentDigits = [[[Digits alloc] init] autorelease];
    }

    NSError *operationError = nil;
    [self.currentDigits negateWithError:&operationError];
    [self updateDisplays];    
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
    self.currentDigits = [[[Digits alloc] init] autorelease];
    self.previousDigits = nil;
    self.resultDigits = nil;
    self.secondaryDisplay = nil;
    self.mainDisplay = nil;
    self.currentOperation = nil;
    self.previousOperation = nil;
    self.previousExpression = nil;
    self.error = nil;
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
    self.error = nil;
}

- (void)dealloc
{
    [self releaseMembers];
    [super dealloc];
}

@end