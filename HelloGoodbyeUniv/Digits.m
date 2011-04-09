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

@synthesize base;
@synthesize allowedDigits;
@synthesize allowedDigitSet;
@synthesize forbiddenDigitSet;
@synthesize digitValues;
@synthesize positive;
@synthesize unsignedDigits;

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
    
    return [NSString stringWithString:someMutableDigits];    
}

- (int)intValue
{
    int result;
    int length;
    NSRange point = [self.unsignedDigits rangeOfString:@"."];
    if (point.length > 0) {
        length = point.location;
    } else {
        length = self.unsignedDigits.length;
    }
    int accumulator = 0;
    int digitValue = 0;
    for (int i = 0; i < length; i++) {
        NSString *digit = [NSString stringWithFormat:@"%C", [self.unsignedDigits characterAtIndex:i]];
        digitValue = [[self.digitValues objectForKey:digit] intValue];
        accumulator += digitValue * pow(self.base, length - 1 - i);
    }
    
    if (self.positive) {
        result = accumulator;
    } else {
        result = -accumulator;
    }
    return result;
}

- (NSNumber *)value
{
    return [NSNumber numberWithInt:[self intValue]];    
}

- (NSString *)signedDigits
{
    NSString *result;
    if (self.unsignedDigits && [self.unsignedDigits isEqualToString:@""]) {
        result = self.positive ? @"" : @"-0";
    } else if (self.unsignedDigits && ![self.unsignedDigits isEqualToString:@""]) {
        result = [NSString stringWithFormat:@"%@%@", 
                self.positive ? @"" : @"-", 
                self.unsignedDigits];
    } else if (!self.unsignedDigits && !self.positive) {
        result = @"-";
    } else {
        result = nil;
    }
    return result;
}

- (NSString *)description
{
    NSString *result;
    if (self.signedDigits && [self.signedDigits isEqualToString:@""]) {
        result = @"0";
    } else if (self.signedDigits && ([self.signedDigits characterAtIndex:0] == [@"." characterAtIndex:0])) {
        result = [@"0" stringByAppendingString:self.signedDigits];
    } else if (self.signedDigits) {
        result = self.signedDigits;
    } else {
        result = @"";
    }
    return result; // TODO should this be autoreleased?
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
        return nil; // early return because it's useless to invoke [super init]
    }

    if (!someBase || (someBase < 2)) {
        NSLog(@"someBase must be greater than 1");
        return nil; // early return because it's useless to invoke [super init]
    }
    
    self = [super init];
    if (self) {
        self.base = someBase;
        self.positive = YES;

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
        if ([scanner scanString:@"-" intoString:NULL]) {
            self.positive = NO;
            [scanner scanString:@" " intoString:NULL];
        }

        NSString *someUnsignedDigits = nil;
        if ([scanner scanUpToCharactersFromSet:self.forbiddenDigitSet intoString:&someUnsignedDigits]) {
            self.unsignedDigits = someUnsignedDigits;
        } else {
            self.unsignedDigits = nil;
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
        return; // early return because the rest of the method is meaningless with bad input
    }
    
    if (![self.allowedDigitSet characterIsMember:[digit characterAtIndex:0]]) {
        NSLog(@"digit '%@' is not an allowed digit", digit);
        return; // early return because the rest of the method is meaningless with bad input
    }
    
    if (([self.unsignedDigits rangeOfString:@"."].length > 0) && [digit isEqualToString:@"."]) {
        NSLog(@"digit '%@' already present in unsigned digits '%@'", digit, self.unsignedDigits);
        return; // early return because the rest of the method is meaningless with bad input
    }
    
    if (!self.unsignedDigits) {
        self.unsignedDigits = @"";
    }
    
    if ([self.unsignedDigits isEqualToString:@""]) {
        if ([digit isEqualToString:@"0"]) {
            // do not add another zero to a lonely zero            
        } else {
            self.unsignedDigits = digit;
        }
    } else {
        self.unsignedDigits = [self.unsignedDigits stringByAppendingString:digit];
    }
    return;
}

- (NSString *)popDigit
{
    NSString *lastDigit;
    int length = self.unsignedDigits.length;
    
    if (self.unsignedDigits) {
        if (length == 0) {
            lastDigit = @"";
            self.unsignedDigits = nil;
        } else if (length == 1) {
            lastDigit = self.unsignedDigits;
            self.unsignedDigits = nil;
        } else {
            lastDigit = [self.unsignedDigits substringFromIndex:length - 1];
            self.unsignedDigits = [self.unsignedDigits substringToIndex:length - 1];
        }
    } else if (!self.positive) {
        self.positive = !self.positive;
        lastDigit = nil;
    } else {
        lastDigit = nil;
    }
    return lastDigit; // TODO should this be autoreleased?
}

- (Digits *)plus:(Digits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    } else {
        int result = self.intValue + secondOperand.intValue;
        return [[[Digits alloc] initWithInt:result base:self.base] autorelease];
    }
}

- (Digits *)minus:(Digits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    } else {
        int result = self.intValue - secondOperand.intValue;
        return [[[Digits alloc] initWithInt:result base:self.base] autorelease];
    }
}

- (Digits *)times:(Digits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    } else {
        int result = self.intValue * secondOperand.intValue;
        return [[[Digits alloc] initWithInt:result base:self.base] autorelease];
    }
}

- (Digits *)divide:(Digits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    } else if (secondOperand.intValue == 0) {
        if (error) {            
            NSDictionary *userDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedString(@"divided by 0", @""),
                                       NSLocalizedDescriptionKey,
                                       nil] autorelease];
            NSError *localError = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:EPERM userInfo:userDict] autorelease];
            *error = localError;
        }
        return nil;
    } else {
        int result = self.intValue / secondOperand.intValue;
        return [[[Digits alloc] initWithInt:result base:self.base] autorelease];
    }
}

- (Digits *)invertWithError:(NSError **)error
{
    if (self.intValue == 0) {
        if (error) {            
            NSDictionary *userDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedString(@"divided by 0", @""),
                                       NSLocalizedDescriptionKey,
                                       nil] autorelease];
            NSError *localError = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:EPERM userInfo:userDict] autorelease];
            *error = localError;
        }
        return nil;
    } else {
        int result = 1 / self.intValue;
        return [[[Digits alloc] initWithInt:result base:self.base] autorelease];
    }
}

- (Digits *)power:(Digits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    } else if ((self.intValue <= 0) && (secondOperand.intValue < 1)) {
        if (error) {            
            NSDictionary *userDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedString(@"raised 0 to a non-positive exponent", @""),
                                       NSLocalizedDescriptionKey,
                                       nil] autorelease];
            NSError *localError = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:EPERM userInfo:userDict] autorelease];
            *error = localError;
        }
        return nil;
    } else {
        int result = pow(self.intValue, secondOperand.intValue);
        return [[[Digits alloc] initWithInt:result base:self.base] autorelease];
    }
}

- (void)negateWithError:(NSError **)error
{
    self.positive = !self.positive;
    return;
}

@end
