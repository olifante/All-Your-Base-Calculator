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
        NSString *unsignedDigits = serializedDigits;
        
        NSRange minusSign = [serializedDigits rangeOfString:@"-"];
        if (minusSign.location == 0) {
            if (minusSign.length > 0) {
                self = nil;
            } else {
                _positive = NO;
                unsignedDigits = [serializedDigits substringFromIndex:1];
            }
        }
        
        NSRange plusSign = [serializedDigits rangeOfString:@"+"];
        if (plusSign.location == 0) {
            if (plusSign.length > 0) {
                self = nil;
            } else {
                self.positive = YES;
                unsignedDigits = [serializedDigits substringFromIndex:1];
            }
        }
        
        self.baseDigits = [allDigits substringToIndex:base];
        self.baseDigitSet = [NSCharacterSet characterSetWithCharactersInString:self.baseDigits];

        NSCharacterSet *unsignedDigitSet = [NSCharacterSet characterSetWithCharactersInString:unsignedDigits];
        assert([self.baseDigitSet isSupersetOfSet:unsignedDigitSet]);
        self.digits = [NSMutableString stringWithString:unsignedDigits];
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
