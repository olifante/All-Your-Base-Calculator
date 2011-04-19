//
//  FloatingDigits.m
//  AllYourBase
//
//  Created by Tiago Henriques on 4/6/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "FloatingDigits.h"

static NSString *allDigits = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

@implementation FloatingDigits

@synthesize fractionalDigits;

- (double)doubleValue
{
    if (self.signedDigits) {
        const char *char_string = [self.signedDigits UTF8String];
        return strtoll(char_string, NULL, self.base);       
    } else
    {
        return 0.;
    }
}

+ (NSString *)parseDigits:(NSString *)someDigits fromBase:(int)someBase
{
    BOOL positive = YES;
    NSString *allowedDigits = [[allDigits substringToIndex:someBase] stringByAppendingString:@"."];
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
    if (someDouble == 0.) {
        return @"0";
    } else
    {
        double i, f;
        f = modf(someDouble, &i);
        assert(someDouble == f + i);
        assert(f < 1.0);
        assert(i == ceil(i));
        
        NSString *allowedDigits = [allDigits substringToIndex:someBase];
        
        NSMutableString *someMutableDigits = [NSMutableString stringWithString:@""];
        if (someDouble < 0) {
            [someMutableDigits appendString:@"-"];
        }
        
        double remainder = fabs(i);
        int maximumBasePower = floor([Digits log:remainder base:someBase]);
        double power;
        unsigned int quotient;
        
        for (unsigned int exponent = maximumBasePower; exponent > 0; exponent--) {
            power = pow(someBase, exponent);
            quotient = remainder / power;
            remainder = fmod(remainder, power);
            [someMutableDigits appendFormat:@"%C", [allowedDigits characterAtIndex:quotient]];
        }
        
        [someMutableDigits appendFormat:@"%C", [allowedDigits characterAtIndex:remainder]];
        
        return [NSString stringWithString:someMutableDigits];
    }
}

- (id)init
{
    self = [self initWithString:@"" base:10];    
    return self;
}

- (id)initWithDouble:(double)someDouble base:(int)someBase
{
    NSString *someDigits = [FloatingDigits convertDouble:someDouble toBase:someBase];
    self = [self initWithString:someDigits base:someBase];
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
        
        self.allowedDigits = [[allDigits substringToIndex:someBase] stringByAppendingString:@"."];
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
        
        NSString *negativePrefix = @"";
        if ([scanner scanString:@"-" intoString:NULL]) {
            negativePrefix = @"-";
            [scanner scanString:@" " intoString:NULL];
        }
        
        NSString *someSignedDigits = nil;
        if ([scanner scanUpToCharactersFromSet:self.forbiddenDigitSet intoString:&someSignedDigits]) {
            self.signedDigits = [negativePrefix stringByAppendingString:someSignedDigits];
        }
    }
    return self;
}

- (id)initWithString:(NSString *)someString
{
    self = [self initWithString:someString base:10];
    return self;
}

- (Digits *)plus:(Digits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    }

    double firstOperandValue = ((FloatingDigits *)self).doubleValue;
    double secondOperandValue = ((FloatingDigits *)secondOperand).doubleValue;

    double result = firstOperandValue + secondOperandValue;
    return [[[FloatingDigits alloc] initWithDouble:result base:self.base] autorelease];
}

- (Digits *)minus:(Digits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    }

    double firstOperandValue = ((FloatingDigits *)self).doubleValue;
    double secondOperandValue = ((FloatingDigits *)secondOperand).doubleValue;
    
    double result = firstOperandValue - secondOperandValue;
    return [[[FloatingDigits alloc] initWithDouble:result base:self.base] autorelease];
}

- (Digits *)times:(Digits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    }
    
    double firstOperandValue = ((FloatingDigits *)self).doubleValue;
    double secondOperandValue = ((FloatingDigits *)secondOperand).doubleValue;
    
    double result = firstOperandValue * secondOperandValue;
    return [[[FloatingDigits alloc] initWithDouble:result base:self.base] autorelease];
}

- (Digits *)divide:(Digits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    } 
    
    double firstOperandValue = ((FloatingDigits *)self).doubleValue;
    double secondOperandValue = ((FloatingDigits *)secondOperand).doubleValue;

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

- (Digits *)invertWithError:(NSError **)error
{
    double operandValue = ((FloatingDigits *)self).doubleValue;
    
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

- (Digits *)power:(Digits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    }
    
    double firstOperandValue = ((FloatingDigits *)self).doubleValue;
    double secondOperandValue = ((FloatingDigits *)secondOperand).doubleValue;

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
