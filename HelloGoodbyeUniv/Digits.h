//
//  Digits.h
//  AllYourBase
//
//  Created by Tiago Henriques on 4/4/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Digits : NSObject {
    int base;
    BOOL positive;
    NSString *unsignedDigits;
    NSString *allowedDigits;
    NSCharacterSet *allowedDigitSet;
    NSCharacterSet *forbiddenDigitSet;
    NSDictionary *digitValues;
}

@property int base;
@property BOOL positive;
@property (retain) NSString *unsignedDigits;
@property (readonly) NSString *signedDigits;
@property (retain) NSString *allowedDigits;
@property (retain) NSCharacterSet *allowedDigitSet;
@property (retain) NSCharacterSet *forbiddenDigitSet;
@property (retain) NSDictionary *digitValues;
@property (readonly) int intValue;
@property (readonly) NSNumber *value;

+ (NSString *)allDigits;
+ (NSString *)allowedDigitsForBase:(int)someBase;
+ (NSCharacterSet *)allowedDigitSetForBase:(int)someBase;
+ (NSCharacterSet *)forbiddenDigitSetForBase:(int)someBase;

+ (double)log:(double)operand base:(int)base;
+ (NSString *)parseDigits:(NSString *)someDigits fromBase:(int)someBase;
+ (NSString *)convertInt:(int)someInt toBase:(int)someBase;

- (NSString *)description;
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
