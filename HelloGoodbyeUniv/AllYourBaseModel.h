//
//  AllYourBaseModel.h
//  AllYourBase
//
//  Created by Tiago Henriques on 3/29/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FloatingDigits.h"
#import "Digits.h"


@interface AllYourBaseModel : NSObject {
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
@property (nonatomic) int base;

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
