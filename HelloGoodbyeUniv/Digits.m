//
//  Digits.m
//  AllYourBase
//
//  Created by Tiago Henriques on 4/4/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "Digits.h"

const NSString *allDigits = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

@implementation Digits

@synthesize base = _base;
@synthesize allowedDigitsString = _allowedDigitsString;
@synthesize allowedDigits = _allowedDigits;
@synthesize forbiddenDigits = _forbiddenDigits;
@synthesize positive = _positive;
@synthesize digits = _digits;

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

- (int)intValue
{
    return [self.text intValue];
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
                    self.digits ? self.digits : @""];
        }
        
    } else {
        return nil;
    }
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

@end
