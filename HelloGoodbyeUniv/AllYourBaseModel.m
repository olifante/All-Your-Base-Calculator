//
//  AllYourBaseModel.m
//  AllYourBase
//
//  Created by Tiago Henriques on 3/29/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseModel.h"

const unichar plus = 0x002b; // + PLUS SIGN
const unichar minus = 0x2212; // − MINUS SIGN
const unichar times = 0x00d7; // × MULTIPLICATION SIGN
const unichar divide = 0x00f7; // ÷ DIVISION SIGN
const unichar negate = 0x2213; // ∓ MINUS-OR-PLUS SIGN
const unichar negative = 0x002d; // - HYPHEN-MINUS
//const unichar negative = 0xfe63; // ﹣ SMALL HYPHEN-MINUS
//const unichar negative = 0x02d7; // ˗ MODIFIER LETTER MINUS SIGN
const unichar point = 0x2027; // ‧ HYPHENATION POINT
//const unichar point = 0x2219; // ∙ BULLET OPERATOR

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

+ (unichar)plus { return plus; }
+ (unichar)minus { return minus; }
+ (unichar)times { return times; }
+ (unichar)divide { return divide; }
+ (unichar)negate { return negate; }
+ (unichar)negative { return negative; }
+ (unichar)point { return point; }

+ (NSString *)plusString { return [NSString stringWithFormat:@"%C", plus]; }
+ (NSString *)minusString { return [NSString stringWithFormat:@"%C", minus]; }
+ (NSString *)timesString { return [NSString stringWithFormat:@"%C", times]; }
+ (NSString *)divideString { return [NSString stringWithFormat:@"%C", divide]; }
+ (NSString *)negateString { return [NSString stringWithFormat:@"%C", negate]; }
+ (NSString *)negativeString { return [NSString stringWithFormat:@"%C", negative]; }
+ (NSString *)pointString { return [NSString stringWithFormat:@"%C", point]; }

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
        self.secondaryDisplay = [self.error localizedDescription];
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
    
    if ([self.currentOperation characterAtIndex:0] == plus) {
        operationResultDigits = [self.previousDigits plus:self.currentDigits withError:operationError];
    } else if ([self.currentOperation characterAtIndex:0] == minus) {
        operationResultDigits = [self.previousDigits minus:self.currentDigits withError:operationError];
    } else if ([self.currentOperation characterAtIndex:0] == times) {
        operationResultDigits = [self.previousDigits times:self.currentDigits withError:operationError];
    } else if ([self.currentOperation characterAtIndex:0] == divide) {
        operationResultDigits = [self.previousDigits divide:self.currentDigits withError:operationError];
    } else if ([self.currentOperation isEqualToString:@"^"]) {
        operationResultDigits = [self.previousDigits power:self.currentDigits withError:operationError];
    } else {
        NSLog(@"unknown operation '%@'", self.currentOperation);
        if (operationError) {            
            NSDictionary *userDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedString(@"unknown operation '%@'", self.currentOperation),
                                       NSLocalizedDescriptionKey,
                                       nil] retain];
            NSError *localError = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:EPERM userInfo:userDict] autorelease];
            *operationError = localError;
            [userDict release];
        }
    }
    
    self.resultDigits = operationResultDigits;
}

- (void)digitPressed:(NSString *)digit
{
    if (self.error) {
        NSLog(@"No action - digits do nothing after error");
        return;
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
            self.previousExpression = [NSString stringWithFormat:@"%@ %@ %@"
                                       , self.previousDigits ? self.previousDigits.description : @""
                                       , self.currentOperation ? self.currentOperation : @""
                                       , self.currentDigits ? self.currentDigits.description : @""
                                       ];
            self.previousDigits = self.resultDigits;
            self.currentDigits = [[[Digits alloc] init] autorelease];
            self.previousOperation = self.currentOperation;
            self.currentOperation = operation;
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
            self.previousExpression = [NSString stringWithFormat:@"%@ %@ %@"
                                       , self.previousDigits ? self.previousDigits.description : @""
                                       , self.currentOperation ? self.currentOperation : @""
                                       , self.currentDigits ? self.currentDigits.description : @""
                                       ];
            self.previousDigits = nil;
            self.currentDigits = self.resultDigits;
            self.previousOperation = self.currentOperation;
            self.currentOperation = nil;        }
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
    if (self.previousOperation) {
        NSLog(@"No action - delete does not alter calculation results");
        return;
    }
    
    NSString *originalDigits = self.currentDigits.signedDigits;
    NSString *poppedDigit = [self.currentDigits popDigit];
    NSLog(@"popped digit '%@' from digits '%@'", poppedDigit, originalDigits);
    [self updateDisplays];    

    if (self.error) {
        self.error = nil;
        NSLog(@"cleaned error after pressing delete");
        return;
    }
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