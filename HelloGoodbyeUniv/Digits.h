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

@property int base;
@property BOOL positive;
@property (retain) NSString *digits;
@property (retain) NSString *allowedDigitsString;
@property (retain) NSCharacterSet *allowedDigits;
@property (retain) NSCharacterSet *forbiddenDigits;

- (id)initWithString:(NSString *)someString;
- (id)initWithString:(NSString *)someString base:(int)someBase;
- (int)intValue;
- (NSNumber *)value;
- (NSString *)text;

@end
