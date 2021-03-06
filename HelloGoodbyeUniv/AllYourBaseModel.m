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
@synthesize previousFirstOperand;
@synthesize previousSecondOperand;
@synthesize base;

# pragma mark overridden methods
- (id)init
{
    self = [super init];
    if (self) {
        self.base = 10;
        self.previousFirstOperand = 0;
        self.previousSecondOperand = 0;
        self.error = nil;
        self.previousDigits = nil;
        self.currentDigits = [[[Digits alloc] initWithBase:10] autorelease];
        [self updateDisplays];
    }
    return self;
}

- (void)dealloc
{
    [self releaseMembers];
    [super dealloc];
}

# pragma mark UITabBarControllerDelegate optional methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"%@ selected", viewController);
}

# pragma mark instance methods

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
    self.previousFirstOperand = 0;
    self.previousSecondOperand = 0;
    self.error = nil;
}

# pragma mark -

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
//        secondOperand = [self.currentDigits.description isEqualToString:@""] ? @"0" : self.currentDigits.description;
        secondOperand = self.currentDigits.description;
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

# pragma mark -

- (void)setBase:(int)someBase
{
    if ((someBase < 2) || (someBase > 100)) {
        NSLog(@"only bases from 2 to 100 are supported");
        return;
    }
    
    if (someBase == self.base) {
        NSLog(@"no sense in changing base to the same base");
        return;
    }
    
    base = someBase;
    
    if (self.currentDigits) {
        if (self.currentDigits.unsignedDigits) {
//            double currentValue = ((FloatingDigits *)self.currentDigits).doubleValue;
//            self.currentDigits = [[Digits alloc] initWithDouble:currentValue base:someBase];
            long long int currentValue = self.currentDigits.integerValue;
            self.currentDigits = [[Digits alloc] initWithLongLong:currentValue base:someBase];
        } else
        {
            self.currentDigits = [[Digits alloc] initWithBase:someBase];
        }
    }
    
    if (self.previousDigits) {
        if (self.previousDigits.unsignedDigits) {
//            double previousValue = ((FloatingDigits *)self.previousDigits).doubleValue;
//            self.previousDigits = [[Digits alloc] initWithDouble:previousValue base:someBase];
            long long int previousValue = self.previousDigits.integerValue;
            self.previousDigits = [[Digits alloc] initWithLongLong:previousValue base:someBase];
        } else
        {
            self.previousDigits = [[Digits alloc] initWithBase:someBase];
        }
    }
    
    if (self.previousOperation && (self.previousOperation != @"=")) {
        NSString *firstOperand = [Digits convertInteger:self.previousFirstOperand toBase:someBase];
        NSString *secondOperand = [Digits convertInteger:self.previousSecondOperand toBase:someBase];
        self.previousExpression = [NSString stringWithFormat:@"%@ %@ %@"
                                   , firstOperand ? firstOperand : @""
                                   , self.previousOperation ? self.previousOperation : @""
                                   , secondOperand ? secondOperand : @""
                                   ];
    } else
    {
        self.previousFirstOperand = 0;
        self.previousSecondOperand = 0;
        self.previousExpression = nil;
        self.previousOperation = nil;
    }

    [self updateDisplays];
}

# pragma mark -

- (BOOL)performPendingOperationWithError:(NSError **)operationError
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
                                       NSLocalizedString(@"unknown operation '%@'", self.currentOperation),
                                       NSLocalizedDescriptionKey,
                                       nil] retain];
            NSError *localError = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:EPERM userInfo:userDict] autorelease];
            *operationError = localError;
            [userDict release];
        }
    }
    
    self.resultDigits = operationResultDigits;
    
    if (*operationError) {
        return NO;
    } else
    {
        return YES;
    }
}

# pragma mark -

- (void)resultPressed
{
    if (self.error) {
        NSLog(@"No action - result does nothing after error");
        return;
    }
    
    if (!self.currentDigits.unsignedDigits && self.currentOperation) {
        NSLog(@"No action - pending operation cannot be performed without a 2nd operand");
    } else if (!self.currentDigits.unsignedDigits && !self.currentOperation) {
        NSLog(@"No action - result cannot be performed on empty operand");
    } else if (self.currentDigits.unsignedDigits && self.currentOperation) {
        NSError *operationError = nil;
        [self performPendingOperationWithError:&operationError];
        
        if (!self.resultDigits && operationError) {
            NSLog(@"binary operation error after pressing result");
            self.error = operationError;
        } else {
            self.previousFirstOperand = [self.previousDigits integerValue];
            self.previousOperation = self.currentOperation;
            self.previousSecondOperand = [self.currentDigits integerValue];
            self.previousExpression = [NSString stringWithFormat:@"%@ %@ %@"
                                       , self.previousDigits ? self.previousDigits.description : @""
                                       , self.currentOperation ? self.currentOperation : @""
                                       , self.currentDigits ? self.currentDigits.description : @""
                                       ];
            self.previousDigits = nil;
            self.currentDigits = self.resultDigits;
            self.currentOperation = nil;        }
    } else if (self.currentDigits.unsignedDigits && !self.currentOperation) {
        self.previousOperation = @"=";
        self.previousExpression = self.currentDigits.description;
        self.resultDigits = [[Digits alloc] 
                             initWithLongLong:[self.currentDigits integerValue] 
                             base:self.base];
        self.currentDigits = self.resultDigits;
        self.previousDigits = nil;
        self.currentOperation = nil;
    } else {
//        assert(NO); // should never reach this point
    }
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
        if (!self.currentDigits.startsWithMinus) {
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
            self.previousFirstOperand = [self.previousDigits integerValue];
            self.previousOperation = self.currentOperation;
            self.previousSecondOperand = [self.currentDigits integerValue];
            self.previousExpression = [NSString stringWithFormat:@"%@ %@ %@"
                                       , self.previousDigits ? self.previousDigits.description : @""
                                       , self.currentOperation ? self.currentOperation : @""
                                       , self.currentDigits ? self.currentDigits.description : @""
                                       ];
            self.previousDigits = self.resultDigits;
            self.currentDigits = [[[Digits alloc] initWithBase:self.base] autorelease];
            self.currentOperation = operation;
        }
    } else { // no pending operation
        self.previousDigits = self.currentDigits;
        self.currentOperation = operation;
        self.currentDigits = [[[Digits alloc] initWithBase:self.base] autorelease];
    }
    
    [self updateDisplays];
}

- (void)digitPressed:(NSString *)digit
{
    if (self.error) {
        NSLog(@"No action - digits do nothing after error");
        return;
    }
    
    if (self.previousOperation) {
        self.currentDigits = [[[Digits alloc] initWithBase:self.base] autorelease];
    }
    
    [self.currentDigits pushDigit:digit];
    
    self.previousOperation = nil;
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

    if (self.error) {
        self.error = nil;
        NSLog(@"cleaned error after pressing delete");
    }

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
        self.previousFirstOperand = 0;
        self.previousSecondOperand = 0;
        self.resultDigits = nil;
        self.currentDigits = [[[Digits alloc] initWithBase:self.base] autorelease];
    }

    [self.currentDigits negate];
    [self updateDisplays];    
}

- (void)cleanPressed
{
    [self releaseMembers];
    self.currentDigits = [[[Digits alloc] initWithBase:self.base] autorelease];
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

@end