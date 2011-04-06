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
@synthesize allowedDigitsString = _allowedDigitsString;
@synthesize allowedDigits = _allowedDigits;
@synthesize forbiddenDigits = _forbiddenDigits;
@synthesize digitValues = _digitValues;
@synthesize positive = _positive;
@synthesize digits = _digits;

+ (double)log:(double)operand base:(int)base
{
    return log(operand)/log(base);
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
    NSString *allowedDigitsString = [allDigits substringToIndex:someBase];

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
        [someMutableDigits appendFormat:@"%C", [allowedDigitsString characterAtIndex:quotient]];
    }
    
    [someMutableDigits appendFormat:@"%C", [allowedDigitsString characterAtIndex:remainder]];
        
    self = [self initWithString:someMutableDigits base:someBase];
    return self;
}

- (id)initWithString:(NSString *)someString base:(int)base
{
    if (!someString) {
        return nil;
    }

    if (!base || (base < 2)) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _base = base;
        _positive = YES;

        _allowedDigitsString = [allDigits substringToIndex:base];
        _allowedDigits = [NSCharacterSet characterSetWithCharactersInString:self.allowedDigitsString];
        _forbiddenDigits = [self.allowedDigits invertedSet];
        
        int length = _allowedDigitsString.length;
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        for (int i = 0; i < length; i++) {
            NSString *digit = [NSString stringWithFormat:@"%C", [self.allowedDigitsString characterAtIndex:i]];
            [dict setObject:[NSNumber numberWithInt:i] forKey:digit]; 
        }
        _digitValues = [NSDictionary dictionaryWithDictionary:dict];

        NSScanner *scanner = [NSScanner scannerWithString:someString];
        
        [scanner scanString:@" " intoString:NULL];
        
        if ([scanner scanString:@"-" intoString:NULL]) {
            _positive = NO;
        }

        NSString *scannedDigits = nil;
        if ([scanner scanUpToCharactersFromSet:self.forbiddenDigits intoString:&scannedDigits]) {
            self.digits = scannedDigits;
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
    if (!digit) {
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

- (Digits *)times:(Digits *)secondOperand
{
    return nil;    
}

- (Digits *)plus:(Digits *)secondOperand
{
    return nil;
}

- (Digits *)minus:(Digits *)secondOperand
{
    return nil;
}

- (Digits *)divide:(Digits *)secondOperand
{
    return nil;
}

- (Digits *)negate
{
    return nil;
}

- (Digits *)invert
{
    return nil;
}

@end
