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
    
    NSString *signedDigits, *allowedDigits;
    NSCharacterSet *allowedDigitSet, *forbiddenDigitSet;
    NSDictionary *digitValues;    
}

@property int base;

@property (nonatomic, retain) NSString *signedDigits, *allowedDigits;
@property (nonatomic, retain) NSCharacterSet *allowedDigitSet, *forbiddenDigitSet;
@property (nonatomic, retain) NSDictionary *digitValues;

- (void)dealloc;
- (NSString *)description;
- (id)init;
- (id)initWithInt:(int)someInt;
- (id)initWithInt:(int)someInt base:(int)someBase;
- (id)initWithString:(NSString *)someString;
- (id)initWithString:(NSString *)someString base:(int)someBase;

@property (nonatomic, readonly) int intValue;
@property (nonatomic, readonly) NSNumber *value;
@property (nonatomic, readonly) NSString *unsignedDigits;
@property (nonatomic, readonly) BOOL isEmpty;
@property (nonatomic, readonly) BOOL startsWithMinus;
@property (nonatomic, readonly) BOOL startsWithPoint;
@property (nonatomic, readonly) BOOL containsPoint;
@property (nonatomic, readonly) unichar zeroChar;

- (void)pushDigit:(NSString *)digit;
- (NSString *)popDigit;
- (void)negate;

- (Digits *)plus:(Digits *)secondOperand withError:(NSError **)error;
- (Digits *)minus:(Digits *)secondOperand withError:(NSError **)error;
- (Digits *)times:(Digits *)secondOperand withError:(NSError **)error;
- (Digits *)divide:(Digits *)secondOperand withError:(NSError **)error;
- (Digits *)invertWithError:(NSError **)error;
- (Digits *)power:(Digits *)secondOperand withError:(NSError **)error;

- (BOOL)isZero:(NSString *)digitString;
- (BOOL)isDigit:(NSString *)digitString;

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

@end
