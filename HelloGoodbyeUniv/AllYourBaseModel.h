//
//  AllYourBaseModel.h
//  AllYourBase
//
//  Created by Tiago Henriques on 3/29/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AllYourBaseModel : NSObject {
    NSString *_firstOperand;
    NSString *_secondOperand;
    NSString *_currentOperand;
    NSString *_pendingOperation;
    NSString *_performedOperation;    
    NSString *_performedExpression;
    NSString *_result;
    NSString *_firstDisplay;
    NSString *_secondDisplay;
}

@property (nonatomic, retain) NSString *firstOperand;
@property (nonatomic, retain) NSString *secondOperand;
@property (nonatomic, retain) NSString *currentOperand;
@property (nonatomic, retain) NSString *performedOperation;
@property (nonatomic, retain) NSString *pendingOperation;
@property (nonatomic, retain) NSString *performedExpression;
@property (nonatomic, retain) NSString *result;
@property (nonatomic, retain) NSString *firstDisplay;
@property (nonatomic, retain) NSString *secondDisplay;

@property (readonly) double firstOperandValue;
@property (readonly) double secondOperandValue;

- (void)performPendingOperation;
- (void)digitPressed:(NSString *)digit;
- (void)periodPressed;
- (void)operationPressed:(NSString *)operation;
- (void)resultPressed;
- (void)releaseMembers;

@end
