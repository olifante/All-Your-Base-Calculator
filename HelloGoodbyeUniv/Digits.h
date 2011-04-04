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
    NSMutableString *digits;
    NSString *_baseDigits;
    NSCharacterSet *_baseDigitSet;
}

@property int base;
@property BOOL positive;
@property (retain) NSMutableString *digits;
@property (retain) NSString *baseDigits;
@property (retain) NSCharacterSet *baseDigitSet;

- (int)intValue;
- (NSNumber *)value;
- (NSString *)text;

@end
