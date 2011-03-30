//
//  AllYourBaseModel.h
//  AllYourBase
//
//  Created by Tiago Henriques on 3/29/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AllYourBaseModel : NSObject {
    NSString *_pendingOperation;
    NSString *_currentDigits;
    NSString *_previousDigits;
    BOOL _operationHasJustBeenPerformed;    
}

@property (nonatomic, retain) NSString *pendingOperation;
@property (nonatomic, retain) NSString *currentDigits;
@property (nonatomic, retain) NSString *previousDigits;
@property (nonatomic, retain) NSString *currentDisplay;
@property (nonatomic, retain) NSString *previousDisplay;
@property BOOL operationHasJustBeenPerformed;

@property (readonly) double currentOperand;
@property (readonly) double previousOperand;

- (void)updateDisplays;
- (void)updatePreviousDisplay;
- (void)updateCurrentDisplay;
- (void)releaseMembers;
- (void)performPendingOperation;

@end
