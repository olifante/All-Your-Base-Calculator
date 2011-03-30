//
//  AllYourBaseModel.h
//  AllYourBase
//
//  Created by Tiago Henriques on 3/29/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AllYourBaseModel : NSObject {
    BOOL _operationHasJustBeenPerformed;    
    NSString *_pendingOperation;
    NSString *_currentDigits;
    NSString *_previousDigits;
}

@property BOOL operationHasJustBeenPerformed;
@property (nonatomic, retain) NSString *pendingOperation;
@property (nonatomic, retain) NSString *currentDigits;
@property (nonatomic, retain) NSString *previousDigits;
@property (readonly) NSString *currentDisplay;
@property (readonly) NSString *previousDisplay;
@property (readonly) double currentOperand;
@property (readonly) double previousOperand;

- (void)digitPressed:(NSString *)digit;
- (void)periodPressed;
- (void)operationPressed:(NSString *)operation;
- (void)resultPressed;
- (void)releaseMembers;
- (void)performPendingOperation;

@end
