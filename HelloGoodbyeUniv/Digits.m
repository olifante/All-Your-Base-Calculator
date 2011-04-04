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
@synthesize positive = _positive;
@synthesize digits = _digits;
@synthesize allowedDigitsString = _allowedDigitsString;
@synthesize allowedDigits = _allowedDigits;
@synthesize forbiddenDigits = _forbiddenDigits;

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
        self.base = base;
        self.positive = YES;

        self.allowedDigitsString = [allDigits substringToIndex:base];
        self.allowedDigits = [NSCharacterSet characterSetWithCharactersInString:self.allowedDigitsString];
        self.forbiddenDigits = [self.allowedDigits invertedSet];
        
        NSScanner *scanner = [NSScanner scannerWithString:someString];
        
        [scanner scanString:@" " intoString:NULL];
        
        if ([scanner scanString:@"-" intoString:NULL]) {
            self.positive = NO;
        }

        NSString *scannedDigits = nil;
        if ([scanner scanUpToCharactersFromSet:self.forbiddenDigits intoString:&scannedDigits]) {
            self.digits = scannedDigits;
        } else {
            self.digits = @"0";
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
    return [NSString stringWithFormat:@"%@%@", 
            self.positive ? @"" : @"-", 
            self.digits ? self.digits : @""];
}

@end
