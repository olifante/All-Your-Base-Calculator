//
//  AllYourBaseModel.h
//  AllYourBase
//
//  Created by Tiago Henriques on 3/29/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AllYourBaseModel : NSObject {
    NSString *_previousDigits;
    NSString *_currentDigits;
    NSString *_currentOperation;
    NSString *_previousOperation;    
    NSString *_previousExpression;
    NSString *_result;
    NSString *_firstDisplay;
    NSString *_secondDisplay;
}

@property (nonatomic, retain) NSString *previousDigits;
@property (nonatomic, retain) NSString *currentDigits;
@property (nonatomic, retain) NSString *previousOperation;
@property (nonatomic, retain) NSString *currentOperation;
@property (nonatomic, retain) NSString *previousExpression;
@property (nonatomic, retain) NSString *result;
@property (nonatomic, retain) NSString *firstDisplay;
@property (nonatomic, retain) NSString *secondDisplay;

@property (readonly) double previousValue;
@property (readonly) double currentValue;

- (void)performPendingOperation;
- (void)digitPressed:(NSString *)digit;
- (void)periodPressed;
- (void)operationPressed:(NSString *)operation;
- (void)resultPressed;
- (void)releaseMembers;

@end
