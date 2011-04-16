//
//  FloatingDigits.m
//  AllYourBase
//
//  Created by Tiago Henriques on 4/6/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "FloatingDigits.h"


@implementation FloatingDigits

@synthesize fractionalDigits;

- (double)doubleValue
{
    double result = 0;
    int length = 0;
    NSRange pointRange = [self.unsignedDigits rangeOfString:@"."];
    if (pointRange.length > 0) {
        length = pointRange.location;
    } else {
        length = self.unsignedDigits.length;
    }
    double accumulator = 0;
    unsigned int digitValue = 0;
    for (int i = 0; i < length; i++) {
        NSString *digit = [NSString stringWithFormat:@"%C", [self.unsignedDigits characterAtIndex:i]];
        digitValue = [[self.digitValues objectForKey:digit] intValue];
        accumulator += digitValue * pow(self.base, length - 1 - i);
    }
    
    if (self.startsWithMinus) {
        result = -accumulator;
    } else {
        result = accumulator;
    }
    return result;
}

+ (NSString *)parseDigits:(NSString *)someDigits fromBase:(int)someBase
{
    BOOL positive = YES;
    NSString *allowedDigits = [[[Digits allDigits] substringToIndex:someBase] stringByAppendingString:@"."];
    NSCharacterSet *allowedDigitSet = [NSCharacterSet characterSetWithCharactersInString:allowedDigits];
    NSCharacterSet *forbiddenDigitSet = [allowedDigitSet invertedSet];
    
    NSScanner *scanner = [NSScanner scannerWithString:someDigits];
    
    [scanner scanString:@" " intoString:NULL];    
    if ([scanner scanString:@"-" intoString:NULL]) {
        positive = NO;
        [scanner scanString:@" " intoString:NULL];    
    }
    
    NSString *unsignedDigits = nil;
    [scanner scanUpToCharactersFromSet:forbiddenDigitSet intoString:&unsignedDigits];
    
    return [NSString stringWithFormat:@"%@%@"
            , positive ? @"" : @"-"
            , unsignedDigits ? unsignedDigits : @""
            ];
}

+ (NSString *)convertDouble:(double)someDouble toBase:(int)someBase
{
    NSLog(@"method stub");
    return @"";
}

- (id)init
{
    self = [self initWithString:@"" base:10];    
    return self;
}

- (id)initWithDouble:(double)someDouble base:(int)someBase
{
    NSLog(@"method stub");
    self = [self initWithString:@"" base:10];
    return self;
}

- (id)initWithDouble:(double)someDouble
{
    self = [self initWithDouble:someDouble base:10];
    return self;
}

- (id)initWithString:(NSString *)someString base:(int)someBase
{
    if (!someString) {
        NSLog(@"someString must not be nil");
        return nil; // early return because it's useless to invoke [super init]
    }
    
    if (!someBase || (someBase < 2)) {
        NSLog(@"someBase must be greater than 1");
        return nil; // early return because it's useless to invoke [super init]
    }
    
    self = [super initWithString:someString base:someBase];
    if (self) {
        self.base = someBase;
        
        self.allowedDigits = [self.allowedDigits stringByAppendingString:@"."];
        self.allowedDigitSet = [NSCharacterSet characterSetWithCharactersInString:self.allowedDigits];
        self.forbiddenDigitSet = [self.allowedDigitSet invertedSet];
        
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        for (int i = 0; i < someBase; i++) {
            NSString *digit = [NSString stringWithFormat:@"%C", [self.allowedDigits characterAtIndex:i]];
            [dict setObject:[NSNumber numberWithInt:i] forKey:digit]; 
        }
        self.digitValues = [NSDictionary dictionaryWithDictionary:dict];
        
        NSScanner *scanner = [NSScanner scannerWithString:someString];
        [scanner scanString:@" " intoString:NULL];
        
        NSString *someSignedDigits = nil;
        if ([scanner scanString:[Digits negativeString] intoString:&someSignedDigits]) {
            [scanner scanString:@" " intoString:NULL];
        }
        
        if ([scanner scanUpToCharactersFromSet:self.forbiddenDigitSet intoString:&someSignedDigits]) {
            self.signedDigits = someSignedDigits;
        }
    }
    return self;
}

- (id)initWithString:(NSString *)someString
{
    self = [self initWithString:someString base:10];
    return self;
}

- (FloatingDigits *)plus:(FloatingDigits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    }

    double firstOperandValue = self.doubleValue;
    double secondOperandValue = secondOperand.doubleValue;

    double result = firstOperandValue + secondOperandValue;
    return [[[FloatingDigits alloc] initWithDouble:result base:self.base] autorelease];
}

- (FloatingDigits *)minus:(FloatingDigits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    }

    double firstOperandValue = self.doubleValue;
    double secondOperandValue = secondOperand.doubleValue;
    
    double result = firstOperandValue - secondOperandValue;
    return [[[FloatingDigits alloc] initWithDouble:result base:self.base] autorelease];
}

- (FloatingDigits *)times:(FloatingDigits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    }
    
    double firstOperandValue = self.doubleValue;
    double secondOperandValue = secondOperand.doubleValue;
    
    double result = firstOperandValue * secondOperandValue;
    return [[[FloatingDigits alloc] initWithDouble:result base:self.base] autorelease];
}

- (FloatingDigits *)divide:(FloatingDigits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    } 
    
    double firstOperandValue = self.doubleValue;
    double secondOperandValue = secondOperand.doubleValue;

    if (secondOperandValue == 0) {
        if (error) {            
            NSDictionary *userDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedString([Digits divideErrorMessage], @""),
                                       NSLocalizedDescriptionKey,
                                       nil] retain];
            NSError *localError = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:EPERM userInfo:userDict] autorelease];
            *error = localError;
            [userDict release];
        }
        return nil;
    } else {
        double result = firstOperandValue / secondOperandValue;
        return [[[FloatingDigits alloc] initWithDouble:result base:self.base] autorelease];
    }
}

- (FloatingDigits *)invertWithError:(NSError **)error
{
    double operandValue = self.doubleValue;
    
    if (operandValue == 0) {
        if (error) {            
            NSDictionary *userDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedString([Digits invertErrorMessage], @""),
                                       NSLocalizedDescriptionKey,
                                       nil] retain];
            NSError *localError = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:EPERM userInfo:userDict] autorelease];
            *error = localError;
            [userDict release];
        }
        return nil;
    } else {
        double result = 1.0 / operandValue;
        return [[[FloatingDigits alloc] initWithDouble:result base:self.base] autorelease];
    }
}

- (FloatingDigits *)power:(FloatingDigits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    }
    
    double firstOperandValue = self.doubleValue;
    double secondOperandValue = secondOperand.doubleValue;

    if ((firstOperandValue == 0) && (secondOperandValue == 0)) {
        if (error) {            
            NSDictionary *userDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedString([Digits zeroPowerOfZeroErrorMessage], @""),
                                       NSLocalizedDescriptionKey,
                                       nil] retain];
            NSError *localError = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:EPERM userInfo:userDict] autorelease];
            *error = localError;
            [userDict release];
        }
        return nil;
    } else if ((firstOperandValue == 0) && (secondOperandValue < 0)) {
        if (error) {            
            NSDictionary *userDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedString([Digits negativePowerOfZeroErrorMessage], @""),
                                       NSLocalizedDescriptionKey,
                                       nil] retain];
            NSError *localError = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:EPERM userInfo:userDict] autorelease];
            *error = localError;
            [userDict release];
        }
        return nil;
    } else if ((firstOperandValue < 0) && ([secondOperand containsPoint])) {
        if (error) {            
            NSDictionary *userDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedString([Digits fractionalPowerOfNegativeErrorMessage], @""),
                                       NSLocalizedDescriptionKey,
                                       nil] retain];
            NSError *localError = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:EPERM userInfo:userDict] autorelease];
            *error = localError;
            [userDict release];
        }
        return nil;
    } else {
        double result = 0.0;
        result = pow(firstOperandValue, secondOperandValue);
        return [[[FloatingDigits alloc] initWithDouble:result base:self.base] autorelease];
    }
}

@end
