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
}

@property (retain) NSString *fractionalDigits;

@property (nonatomic, readonly) double doubleValue;

+ (NSString *)convertDouble:(double)someDouble toBase:(int)someBase;

- (id)init;
- (id)initWithBase:(int)someBase;
- (id)initWithDouble:(double)someDouble base:(int)someBase;
- (id)initWithDouble:(double)someDouble;
- (id)initWithString:(NSString *)someString base:(int)someBase;
- (id)initWithString:(NSString *)someString;

- (Digits *)plus:(Digits *)secondOperand withError:(NSError **)error;
- (Digits *)minus:(Digits *)secondOperand withError:(NSError **)error;
- (Digits *)times:(Digits *)secondOperand withError:(NSError **)error;
- (Digits *)divide:(Digits *)secondOperand withError:(NSError **)error;
- (Digits *)invertWithError:(NSError **)error;
- (Digits *)power:(Digits *)secondOperand withError:(NSError **)error;

@end