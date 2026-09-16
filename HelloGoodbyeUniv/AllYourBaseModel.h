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

@interface AllYourBaseModel : NSObject <UITabBarControllerDelegate>

@property (nonatomic, strong) Digits *currentDigits;
@property (nonatomic, strong) Digits *previousDigits;
@property (nonatomic, strong) Digits *resultDigits;
@property (nonatomic, strong) NSString *currentOperation;
@property (nonatomic, strong) NSString *previousOperation;
@property (nonatomic, strong) NSString *previousExpression;
@property (nonatomic, strong) NSString *mainDisplay;
@property (nonatomic, strong) NSString *secondaryDisplay;
@property (nonatomic, strong) NSError *error;
@property (nonatomic) int previousFirstOperand;
@property (nonatomic) int previousSecondOperand;
@property (nonatomic) int base;

- (instancetype)init;

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
