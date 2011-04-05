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
    NSString *_allowedDigitsString;
    NSCharacterSet *_allowedDigits;
    NSCharacterSet *_forbiddenDigits;
    NSDictionary *_digitValues;
}

@property (readonly) int base;
@property (readonly) BOOL positive;
@property (retain) NSString *digits;
@property (readonly, retain) NSString *allowedDigitsString;
@property (readonly, retain) NSCharacterSet *allowedDigits;
@property (readonly, retain) NSCharacterSet *forbiddenDigits;
@property (readonly, retain) NSDictionary *digitValues;
@property (readonly) int intValue;
@property (readonly) NSNumber *value;
@property (readonly) NSString *text;

- (id)initWithInt:(int)someInt base:(int)base;
- (id)initWithString:(NSString *)someString;
- (id)initWithString:(NSString *)someString base:(int)someBase;
- (void)pushDigit:(NSString *)digit;
- (NSString *)popDigit;
- (Digits *)times:(Digits *)secondOperand;
- (Digits *)plus:(Digits *)secondOperand;
- (Digits *)minus:(Digits *)secondOperand;
- (Digits *)divide:(Digits *)secondOperand;
- (Digits *)negate;
- (Digits *)invert;

@end
