//
//  Digits.m
//  AllYourBase
//
//  Created by Tiago Henriques on 4/4/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "Digits.h"

const NSString *allDigits = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

@implementation Digits

@synthesize base = _base;
@synthesize allowedDigits = _allowedDigits;
@synthesize allowedDigitSet = _allowedDigitSet;
@synthesize forbiddenDigitSet = _forbiddenDigitSet;
@synthesize digitValues = _digitValues;
@synthesize positive = _positive;
@synthesize digits = _digits;

+ (NSString *)allDigits
{
    return [[allDigits copy] autorelease];
}

+ (NSString *)allowedDigitsForBase:(int)someBase
{
    return [[Digits allDigits] substringToIndex:someBase];
}

+ (NSCharacterSet *)allowedDigitSetForBase:(int)someBase
{
    NSString *allowedDigits = [Digits allowedDigitsForBase:someBase];
    NSCharacterSet *allowedDigitSet = [NSCharacterSet characterSetWithCharactersInString:allowedDigits];
    return allowedDigitSet;
}

+ (NSCharacterSet *)forbiddenDigitSetForBase:(int)someBase
{
    return [[Digits allowedDigitSetForBase:someBase] invertedSet];
}

+ (double)log:(double)operand base:(int)base
{
    return log(operand)/log(base);
}

+ (NSString *)parseDigits:(NSString *)someDigits fromBase:(int)someBase
{
    BOOL positive = YES;
    NSString *allowedDigits = [allDigits substringToIndex:someBase];
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

+ (NSString *)convertInt:(int)someInt toBase:(int)someBase
{
    NSString *allowedDigits = [allDigits substringToIndex:someBase];
    
    NSMutableString *someMutableDigits = [NSMutableString stringWithString:@""];
    if (someInt < 0) {
        [someMutableDigits appendString:@"-"];
    }
    
    int remainder = abs(someInt);
    int maximumBasePower = floor([Digits log:remainder base:someBase]);
    int power, quotient;
    
    for (int exponent = maximumBasePower; exponent > 0; exponent--) {
        power = pow(someBase, exponent);
        quotient = remainder / power;
        remainder = remainder % power;
        [someMutableDigits appendFormat:@"%C", [allowedDigits characterAtIndex:quotient]];
    }
    
    [someMutableDigits appendFormat:@"%C", [allowedDigits characterAtIndex:remainder]];
    
    return [[[NSString stringWithString:someMutableDigits] copy] autorelease];    
}

- (int)intValue
{
    int length = self.digits.length;
    int accumulator = 0;
    int digitValue = 0;
    for (int i = 0; i < length; i++) {
        NSString *digit = [NSString stringWithFormat:@"%C", [self.digits characterAtIndex:i]];
        digitValue = [[self.digitValues objectForKey:digit] intValue];
        accumulator += digitValue * pow(_base, length - 1 - i);
    }
    
    if (self.positive) {
        return accumulator;
    } else {
        return -accumulator;
    }
}

- (NSNumber *)value
{
    return [NSNumber numberWithInt:[self intValue]];    
}

- (NSString *)text
{
    if (self.digits) {
        if ([self.digits isEqualToString:@""]) {
            return @"0";
        } else {
            return [NSString stringWithFormat:@"%@%@", 
                    self.positive ? @"" : @"-", 
                    self.digits];
        }
        
    } else {
        return nil;
    }
}

- (id)initWithInt:(int)someInt
{
    self = [self initWithInt:someInt base:10];
    return self;
}

- (id)initWithInt:(int)someInt base:(int)someBase
{
    NSString *someDigits = [Digits convertInt:someInt toBase:someBase];
    self = [self initWithString:someDigits base:someBase];
    return self;
}

- (id)initWithString:(NSString *)someString base:(int)someBase
{
    if (!someString) {
        NSLog(@"someString must not be nil");
        return nil;
    }

    if (!someBase || (someBase < 2)) {
        NSLog(@"someBase must be greater than 1");
        return nil;
    }
    
    self = [super init];
    if (self) {
        _base = someBase;
        _positive = YES;

        _allowedDigits = [allDigits substringToIndex:someBase];
        _allowedDigitSet = [NSCharacterSet characterSetWithCharactersInString:self.allowedDigits];
        _forbiddenDigitSet = [self.allowedDigitSet invertedSet];
        
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        for (int i = 0; i < someBase; i++) {
            NSString *digit = [NSString stringWithFormat:@"%C", [self.allowedDigits characterAtIndex:i]];
            [dict setObject:[NSNumber numberWithInt:i] forKey:digit]; 
        }
        _digitValues = [NSDictionary dictionaryWithDictionary:dict];

        NSScanner *scanner = [NSScanner scannerWithString:someString];
        
        [scanner scanString:@" " intoString:NULL];
        if ([scanner scanString:@"-" intoString:NULL]) {
            _positive = NO;
            [scanner scanString:@" " intoString:NULL];
        }

        NSString *unsignedDigits = nil;
        if ([scanner scanUpToCharactersFromSet:self.forbiddenDigitSet intoString:&unsignedDigits]) {
            self.digits = unsignedDigits;
        } else {
            self.digits = @"";
        }
    }
    return self;
}

- (id)initWithString:(NSString *)someString
{
    self = [self initWithString:someString base:10];
    return self;
}

- (id)init
{
    self = [self initWithString:@"" base:10];    
    return self;
}

- (void)pushDigit:(NSString *)digit
{
    if (!digit || (digit.length != 1)) {
        NSLog(@"digit must be one single character");
        return;
    }
    
    if (![self.allowedDigitSet characterIsMember:[digit characterAtIndex:0]]) {
        NSLog(@"digit '%@' is not an allowed digit", digit);
        return;
    }
    
    if ([self.digits isEqualToString:@""]) {
        if ([digit isEqualToString:@"0"]) {
            // do not add another zero to a lonely zero            
        } else {
            self.digits = digit;
        }
    } else {
        self.digits = [self.digits stringByAppendingString:digit];
    }
}

- (NSString *)popDigit
{
    NSString *lastDigit;
    int length = self.digits.length;
    if (length < 1) {
        lastDigit = nil;
    } else {
        lastDigit = [self.digits substringFromIndex:length - 1];
        self.digits = [self.digits substringToIndex:length - 1];
    }
    return lastDigit;
}

- (Digits *)plus:(Digits *)secondOperand
{
    int result = self.intValue + secondOperand.intValue;
    return [[[Digits alloc] initWithInt:result base:self.base] autorelease];
}

- (Digits *)minus:(Digits *)secondOperand
{
    int result = self.intValue - secondOperand.intValue;
    return [[[Digits alloc] initWithInt:result base:self.base] autorelease];
}

- (Digits *)times:(Digits *)secondOperand
{
    int result = self.intValue * secondOperand.intValue;
    return [[[Digits alloc] initWithInt:result base:self.base] autorelease];
}

- (Digits *)divide:(Digits *)secondOperand
{
    int result = self.intValue / secondOperand.intValue;
    return [[[Digits alloc] initWithInt:result base:self.base] autorelease];
}

- (Digits *)negate
{
    _positive = !_positive;
    return self;
}

- (Digits *)invert
{
    int result = 1 / self.intValue;
    return [[[Digits alloc] initWithInt:result base:self.base] autorelease];
}

- (Digits *)power:(Digits *)secondOperand
{
    int result = pow(self.intValue, secondOperand.intValue);
    return [[[Digits alloc] initWithInt:result base:self.base] autorelease];
}

@end
