//
//  FloatingDigits.m
//  AllYourBase
//
//  Created by Tiago Henriques on 4/6/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "FloatingDigits.h"


@implementation FloatingDigits

@synthesize fractionalDigits;

+ (NSString *)parseDigits:(NSString *)someDigits fromBase:(int)someBase
{
    BOOL positive = YES;
    NSString *allowedDigits = [[[Digits allDigits] substringToIndex:someBase] stringByAppendingString:@"."];
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
    return @"";
}

- (id)initWithDouble:(double)someDouble
{
    self = [self initWithDouble:someDouble base:10];
    return self;
}

- (id)initWithDouble:(double)someDouble base:(int)someBase
{
    self = [self initWithInt:(int)someDouble base:10];
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
        
        self.allowedDigits = [self.allowedDigits stringByAppendingString:@"."];
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
@end
