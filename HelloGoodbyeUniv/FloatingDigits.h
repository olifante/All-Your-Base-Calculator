//
//  FloatingDigits.h
//  AllYourBase
//
//  Created by Tiago Henriques on 4/6/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Digits.h"

@interface FloatingDigits : Digits

@property (nonatomic, strong) NSString *fractionalDigits;

@property (nonatomic, readonly) double doubleValue;

+ (NSString *)convertDouble:(double)someDouble toBase:(int)someBase;

- (instancetype)init;
- (instancetype)initWithBase:(int)someBase;
- (instancetype)initWithDouble:(double)someDouble base:(int)someBase;
- (instancetype)initWithDouble:(double)someDouble;
- (instancetype)initWithString:(NSString *)someString base:(int)someBase;
- (instancetype)initWithString:(NSString *)someString;

- (Digits *)plus:(Digits *)secondOperand withError:(NSError **)error;
- (Digits *)minus:(Digits *)secondOperand withError:(NSError **)error;
- (Digits *)times:(Digits *)secondOperand withError:(NSError **)error;
- (Digits *)divide:(Digits *)secondOperand withError:(NSError **)error;
- (Digits *)invertWithError:(NSError **)error;
- (Digits *)power:(Digits *)secondOperand withError:(NSError **)error;

@end