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

@class AllYourBaseViewController;

@interface AllYourBaseModel : NSObject <UITabBarControllerDelegate> {
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
@property (nonatomic) int previousFirstOperand;
@property (nonatomic) int previousSecondOperand;
@property (nonatomic) int base;

- (id)init;
- (void)dealloc;

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

- (void)releaseMembers;

- (void)updateDisplays;

- (BOOL)performPendingOperationWithError:(NSError **)operationError;

- (void)resultPressed;
- (void)binaryOperationPressed:(NSString *)operation;
- (void)digitPressed:(NSString *)digit;
- (void)deletePressed;
- (void)negatePressed;
- (void)cleanPressed;
- (void)shiftLeftPressed;
- (void)shiftRightPressed;
- (void)percentPressed;
- (void)EEPressed;

@end
