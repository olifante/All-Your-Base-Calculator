//
//  AllYourBaseModel.h
//  AllYourBase
//
//  Created by Tiago Henriques on 3/29/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Digits.h"


@interface AllYourBaseModel : NSObject {
    Digits *currentDigits;
    Digits *previousDigits;
    Digits *resultDigits;
    NSString *currentOperation;
    NSString *previousOperation;    
    NSString *previousExpression;
    NSString *previousDisplay;
    NSString *currentDisplay;
    NSError *error;
}

@property (nonatomic, retain) Digits *currentDigits;
@property (nonatomic, retain) Digits *previousDigits;
@property (nonatomic, retain) Digits *resultDigits;
@property (nonatomic, retain) NSString *currentOperation;
@property (nonatomic, retain) NSString *previousOperation;
@property (nonatomic, retain) NSString *previousExpression;
@property (nonatomic, retain) NSString *mainDisplay;
@property (nonatomic, retain) NSString *secondaryDisplay;
@property (nonatomic, retain) NSError *error;

+ (unichar)plus;
+ (unichar)minus;
+ (unichar)times;
+ (unichar)divide;
+ (unichar)negate;
+ (unichar)negative;
+ (unichar)point;

+ (NSString *)plusString;
+ (NSString *)minusString;
+ (NSString *)timesString;
+ (NSString *)divideString;
+ (NSString *)negateString;
+ (NSString *)negativeString;
+ (NSString *)pointString;

- (id)init;
- (void)updateDisplays;
- (void)performPendingOperationWithError:(NSError **)operationError;
- (void)digitPressed:(NSString *)digit;
- (void)binaryOperationPressed:(NSString *)operation;
- (void)resultPressed;
- (void)cleanPressed;
- (void)deletePressed;
- (void)negatePressed;
- (void)shiftLeftPressed;
- (void)shiftRightPressed;
- (void)EEPressed;
- (void)percentPressed;
- (void)releaseMembers;

@end
