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

+ (NSString *)convertDouble:(double)someDouble toBase:(int)someBase;

- (id)initWithDouble:(double)someDouble;
- (id)initWithDouble:(double)someDouble base:(int)someBase;
- (id)initWithString:(NSString *)someString base:(int)someBase;

@end