//
//  RationalDigits.h
//  AllYourBase
//
//  Created by Tiago Henriques on 4/6/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Digits.h"

@interface RationalDigits: Digits {
}

@property (retain) NSString *denominatorDigits;

+ (NSString *)convertNumerator:(int)numerator denominator:(int)denominator toBase:(int)someBase;

- (id)initWithNumerator:(int)numerator denominator:(int)denominator;
- (id)initWithNumerator:(int)numerator denominator:(int)denominator base:(int)someBase;

@end