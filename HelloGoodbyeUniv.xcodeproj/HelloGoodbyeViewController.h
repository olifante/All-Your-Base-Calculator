//
//  HelloGoodbyeViewController.h
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKString.h"

@interface HelloGoodbyeViewController : UIViewController {
    UILabel *_label;
    NSString *_pendingOperation;
    NSString *_currentDigits;
    NSString *_previousDigits;
    BOOL _operationHasJustBeenPerformed;
}

@property (retain) IBOutlet UILabel *label;
@property (retain) IBOutlet UILabel *pendingLabel, *currentLabel, *previousLabel, *resultsLabel;
@property (nonatomic, retain) NSString *pendingOperation;
@property (nonatomic, retain) NSString *currentDigits;
@property (nonatomic, retain) NSString *previousDigits;
@property BOOL operationHasJustBeenPerformed;

@property (readonly) double currentOperand;
@property (readonly) double previousOperand;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)resultPressed:(UIButton *)sender;
- (IBAction)cleanAll;

@end
