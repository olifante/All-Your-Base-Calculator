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
    NSString *signedDigits;
    NSString *allowedDigits;
    NSCharacterSet *allowedDigitSet;
    NSCharacterSet *forbiddenDigitSet;
    NSDictionary *digitValues;    
}

@property int base;

@property (retain) NSString *signedDigits, *allowedDigits;
@property (retain) NSCharacterSet *allowedDigitSet, *forbiddenDigitSet;
@property (retain) NSDictionary *digitValues;

@property (readonly) int intValue;
@property (readonly) NSNumber *value;
@property (readonly) NSString *unsignedDigits;
@property (readonly) BOOL isEmpty;
@property (readonly) BOOL startsWithMinus;
@property (readonly) BOOL startsWithPoint;
@property (readonly) BOOL containsPoint;
@property (readonly) unichar zeroChar;

+ (NSString *)allDigits;
+ (NSString *)pointString;
+ (NSString *)negativeString;

+ (NSString *)divideErrorMessage;
+ (NSString *)invertErrorMessage;
+ (NSString *)zeroPowerOfZeroErrorMessage;
+ (NSString *)negativePowerOfZeroErrorMessage;
+ (NSString *)fractionalPowerOfNegativeErrorMessage;

+ (NSString *)allowedDigitsForBase:(int)someBase;
+ (NSCharacterSet *)allowedDigitSetForBase:(int)someBase;
+ (NSCharacterSet *)forbiddenDigitSetForBase:(int)someBase;

+ (double)log:(double)operand base:(int)base;
+ (NSString *)parseDigits:(NSString *)someDigits fromBase:(int)someBase;
+ (NSString *)convertInt:(int)someInt toBase:(int)someBase;

+ (BOOL)startsWithMinus:(NSString *)someString;
+ (BOOL)startsWithPoint:(NSString *)digitString;
+ (BOOL)containsPoint:(NSString *)digitString;
+ (BOOL)isEmpty:(NSString *)digitString;

- (id)initWithInt:(int)someInt;
- (id)initWithInt:(int)someInt base:(int)someBase;
- (id)initWithString:(NSString *)someString;
- (id)initWithString:(NSString *)someString base:(int)someBase;

- (NSString *)description;

- (BOOL)isZero:(NSString *)digitString;
- (BOOL)isDigit:(NSString *)digitString;

- (void)pushDigit:(NSString *)digit;
- (NSString *)popDigit;

- (Digits *)plus:(Digits *)secondOperand withError:(NSError **)error;
- (Digits *)minus:(Digits *)secondOperand withError:(NSError **)error;
- (Digits *)times:(Digits *)secondOperand withError:(NSError **)error;
- (Digits *)divide:(Digits *)secondOperand withError:(NSError **)error;
- (Digits *)invertWithError:(NSError **)error;
- (Digits *)power:(Digits *)secondOperand withError:(NSError **)error;

- (void)negate;

@end
