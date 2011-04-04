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
@synthesize baseDigits = _baseDigits;
@synthesize baseDigitSet = _baseDigitSet;

- (id)initWithString:(NSString *)serializedDigits base:(int)base
{
    assert(base > 2);
    
    self = [super init];
    if (self) {
        self.baseDigits = [allDigits substringToIndex:base];
        self.baseDigitSet = [NSCharacterSet characterSetWithCharactersInString:self.baseDigits];
        NSString *trimmedDigits = [serializedDigits stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSCharacterSet *unsignedDigitSet = [NSCharacterSet characterSetWithCharactersInString:trimmedDigits];
        assert([self.baseDigitSet isSupersetOfSet:unsignedDigitSet]);

        NSScanner *scanner = [NSScanner scannerWithString:trimmedDigits];
        NSString *scannedDigits = nil;
        if ([scanner scanString:@"-" intoString:NULL]) {
            self.positive = NO;
            if ([scanner scanCharactersFromSet:self.baseDigitSet intoString:&scannedDigits]) {
                self.digits = [NSMutableString stringWithString:scannedDigits];
            }
        }
    }
    return self;
}

- (id)initWithString:(NSString *)serializedDigits
{
    self = [self initWithString:serializedDigits base:10];
    return self;
}

- (id)init
{
    self = [self initWithString:nil base:10];    
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
    NSString *sign = self.positive ? @"" : @"-";
    return [NSString stringWithFormat:@"%@%@", sign, self.digits];
}

@end
