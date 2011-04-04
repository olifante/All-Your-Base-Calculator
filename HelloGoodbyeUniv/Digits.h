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
}

@property (readonly) int base;
@property (readonly) BOOL positive;
@property (retain) NSString *digits;
@property (readonly, retain) NSString *allowedDigitsString;
@property (readonly, retain) NSCharacterSet *allowedDigits;
@property (readonly, retain) NSCharacterSet *forbiddenDigits;

- (id)initWithString:(NSString *)someString;
- (id)initWithString:(NSString *)someString base:(int)someBase;
- (int)intValue;
- (NSNumber *)value;
- (NSString *)text;
- (void)pushDigit:(NSString *)digit;
- (NSString *)popDigit;

@end
