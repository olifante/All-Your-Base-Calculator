//
//  HelloGoodbyeViewController.h
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelloGoodbyeViewController : UIViewController {
    UILabel * _label;
    NSString * _pendingOperation;
    NSString * _currentDigits;
    NSString * _previousDigits;
    BOOL _operationHasJustBeenPerformed;
}

@property (retain) IBOutlet UILabel * label;
@property (nonatomic, copy) NSString * pendingOperation;
@property (nonatomic, copy) NSString * currentDigits;
@property (nonatomic, copy) NSString * previousDigits;
@property BOOL operationHasJustBeenPerformed;

@property (readonly) double currentOperand;
@property (readonly) double previousOperand;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)resultPressed:(UIButton *)sender;
- (IBAction)cleanAll;

@end
