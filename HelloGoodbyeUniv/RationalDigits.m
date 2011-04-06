//
//  RationalDigits.m
//  AllYourBase
//
//  Created by Tiago Henriques on 4/6/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "RationalDigits.h"


@implementation RationalDigits

@synthesize denominatorDigits = _denominatorDigits;

+ (NSString *)parseDigits:(NSString *)someDigits fromBase:(int)someBase
{
    BOOL positive = YES;
    NSString *allowedDigits = [[Digits allDigits] substringToIndex:someBase];
    NSCharacterSet *allowedDigitSet = [NSCharacterSet characterSetWithCharactersInString:allowedDigits];
    NSCharacterSet *forbiddenDigitSet = [allowedDigitSet invertedSet];
    
    NSScanner *scanner = [NSScanner scannerWithString:someDigits];
    
    [scanner scanString:@" " intoString:NULL];    
    if ([scanner scanString:@"-" intoString:NULL]) {
        positive = NO;
        [scanner scanString:@" " intoString:NULL];    
    }
    
    NSString *numeratorDigits = nil;
    [scanner scanUpToCharactersFromSet:forbiddenDigitSet intoString:&numeratorDigits];
    
    NSString *denominatorDigits = nil;
    [scanner scanString:@" " intoString:NULL];    
    if ([scanner scanString:@"/" intoString:NULL]) {
        [scanner scanString:@" " intoString:NULL];    
        [scanner scanUpToCharactersFromSet:forbiddenDigitSet intoString:&denominatorDigits];
    }

    return [NSString stringWithFormat:@"%@%@%@%@"
            , positive ? @"" : @"-"
            , numeratorDigits ? numeratorDigits : @""
            , denominatorDigits ? @"/" : @""
            , denominatorDigits ? denominatorDigits : @""
            ];
}

+ (NSString *)convertNumerator:(int)numerator denominator:(int)denominator toBase:(int)someBase
{
    return @"";
}

- (id)initWithNumerator:(int)numerator denominator:(int)denominator
{
    return nil;
}

- (id)initWithNumerator:(int)numerator denominator:(int)denominator base:(int)someBase
{
    return nil;
}

@end
