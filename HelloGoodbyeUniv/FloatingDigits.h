//
//  FloatingDigits.h
//  AllYourBase
//
//  Created by Tiago Henriques on 4/6/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Digits.h"

@interface FloatingDigits: Digits {
    NSString *fractionalDigits;
}

@property (retain) NSString *fractionalDigits;

@property (nonatomic, readonly) double doubleValue;

+ (NSString *)convertDouble:(double)someDouble toBase:(int)someBase;

- (id)init;
- (id)initWithDouble:(double)someDouble base:(int)someBase;
- (id)initWithDouble:(double)someDouble;
- (id)initWithString:(NSString *)someString base:(int)someBase;
- (id)initWithString:(NSString *)someString;

- (FloatingDigits *)plus:(FloatingDigits *)secondOperand withError:(NSError **)error;
- (FloatingDigits *)minus:(FloatingDigits *)secondOperand withError:(NSError **)error;
- (FloatingDigits *)times:(FloatingDigits *)secondOperand withError:(NSError **)error;
- (FloatingDigits *)divide:(FloatingDigits *)secondOperand withError:(NSError **)error;
- (FloatingDigits *)invertWithError:(NSError **)error;
- (FloatingDigits *)power:(FloatingDigits *)secondOperand withError:(NSError **)error;

@end