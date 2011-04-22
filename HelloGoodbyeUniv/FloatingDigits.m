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

- (double)doubleValue // TODO fix doubleValue to include fractional digits in calculations
{
    double result = 0.;
    NSString *digits = self.signedDigits;
    
    if (digits) {
        NSRange pointRange = [digits rangeOfString:@"."];

        if (pointRange.length == 0) {
            const char *char_string = [digits UTF8String];
            result = strtoll(char_string, NULL, self.base);   
        } else 
        if (pointRange.length == 1) {
            const char *char_string = [digits UTF8String];
            double integralValue = strtoll(char_string, NULL, self.base);
            const char *fractional_char_string = [[digits substringFromIndex:(pointRange.location+1)] UTF8String];
            long long int unsignedFractionalDigitsAsInteger = strtoll(fractional_char_string, NULL, self.base);
            double unsignedFractionalValue \
            = unsignedFractionalDigitsAsInteger * pow((double)self.base, -(double)strlen(fractional_char_string));
            if (self.startsWithMinus) {
                result = -unsignedFractionalValue - fabs(integralValue);
            } else
            {
                result = unsignedFractionalValue + fabs(integralValue);
            }
        }        
    }
    return result;
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
    if (isnan(someDouble)) {
        return nil;
    }
    
    if (isinf(someDouble)) {
        return nil;
    }

    NSString *result = @"";
    NSString *allowedDigits = [allDigits substringToIndex:someBase];
//    unichar zero = [allowedDigits characterAtIndex:0];
    int negative = signbit(someDouble);
    double absoluteValue = fabs(someDouble);

    if (absoluteValue == 0.) {
        result = [allowedDigits substringToIndex:1]; // 
    } else
    {
        double integralValue, fractionalValue;
        fractionalValue = modf(absoluteValue, &integralValue);
        assert(absoluteValue == fractionalValue + integralValue);
        assert(fractionalValue < 1.0);
        assert(integralValue == ceil(integralValue));
        
        NSString *integralDigits = [Digits convertInteger:integralValue toBase:someBase];
        NSString *trimmedFractionalDigits = @"";
        
        if (fractionalValue != 0.) {            
            NSString *fractionalDigits \
            = [[NSString stringWithFormat:@"%f", fabs(fractionalValue)] substringFromIndex:1]; // ignore leading zero

            NSError *error = NULL;

            NSRegularExpression *regex \
            = [NSRegularExpression 
               regularExpressionWithPattern:@"0+$" // TODO build regex using zero unichar
               options:NSRegularExpressionCaseInsensitive
               error:&error
               ];

            trimmedFractionalDigits \
            = [regex
               stringByReplacingMatchesInString:fractionalDigits
               options:0
               range:NSMakeRange(0, [fractionalDigits length])
               withTemplate:@"" // trim final zeros
               ];
        }
        result = [NSString 
                  stringWithFormat:@"%@%@%@"
                  , negative ? @"-" : @""
                  , integralDigits
                  , trimmedFractionalDigits
                  ];
    }
    return result;
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
    
    self = [super initWithString:@"" base:someBase];
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
