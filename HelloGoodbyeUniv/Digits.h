//
//  Digits.h
//  AllYourBase
//
//  Created by Tiago Henriques on 4/4/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Digits : NSObject {
    int _base;
    BOOL _positive;
    NSString *_digits;
    NSString *_allowedDigits;
    NSCharacterSet *_allowedDigitSet;
    NSCharacterSet *_forbiddenDigitSet;
    NSDictionary *_digitValues;
}

@property (readonly) int base;
@property (readonly) BOOL positive;
@property (retain) NSString *digits;
@property (readonly, retain) NSString *allowedDigits;
@property (readonly, retain) NSCharacterSet *allowedDigitSet;
@property (readonly, retain) NSCharacterSet *forbiddenDigitSet;
@property (readonly, retain) NSDictionary *digitValues;
@property (readonly) int intValue;
@property (readonly) NSNumber *value;
@property (readonly) NSString *text;

+ (NSString *)allDigits;
+ (NSString *)allowedDigitsForBase:(int)someBase;
+ (NSCharacterSet *)allowedDigitSetForBase:(int)someBase;
+ (NSCharacterSet *)forbiddenDigitSetForBase:(int)someBase;

+ (double)log:(double)operand base:(int)base;
+ (NSString *)parseDigits:(NSString *)someDigits fromBase:(int)someBase;
+ (NSString *)convertInt:(int)someInt toBase:(int)someBase;

- (id)initWithInt:(int)someInt;
- (id)initWithInt:(int)someInt base:(int)someBase;
- (id)initWithString:(NSString *)someString;
- (id)initWithString:(NSString *)someString base:(int)someBase;
- (void)pushDigit:(NSString *)digit;
- (NSString *)popDigit;
- (Digits *)plus:(Digits *)secondOperand;
- (Digits *)minus:(Digits *)secondOperand;
- (Digits *)times:(Digits *)secondOperand;
- (Digits *)divide:(Digits *)secondOperand;
- (Digits *)negate;
- (Digits *)invert;
- (Digits *)power:(Digits *)secondOperand;

@end
