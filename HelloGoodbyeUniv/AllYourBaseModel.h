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
    BOOL _error;
    Digits *_previousDigits;
    Digits *_currentDigits;
    NSString *_currentOperation;
    NSString *_previousOperation;    
    NSString *_previousExpression;
    NSString *_result;
    NSString *_previousDisplay;
    NSString *_currentDisplay;
}

@property BOOL error;
@property (nonatomic, retain) Digits *previousDigits;
@property (nonatomic, retain) Digits *currentDigits;
@property (nonatomic, retain) NSString *previousOperation;
@property (nonatomic, retain) NSString *currentOperation;
@property (nonatomic, retain) NSString *previousExpression;
@property (nonatomic, retain) NSString *result;
@property (nonatomic, retain) NSString *previousDisplay;
@property (nonatomic, retain) NSString *currentDisplay;

@property (readonly) double previousValue;
@property (readonly) double currentValue;

- (id)init;
- (void)updateDisplays;
- (void)performPendingOperation;
- (void)digitPressed:(NSString *)digit;
- (void)periodPressed;
- (void)binaryOperationPressed:(NSString *)operation;
- (void)resultPressed;
- (void)deletePressed;
- (void)negatePressed;
- (void)shiftLeftPressed;
- (void)shiftRightPressed;
- (void)EEPressed;
- (void)percentPressed;
- (void)releaseMembers;

@end
