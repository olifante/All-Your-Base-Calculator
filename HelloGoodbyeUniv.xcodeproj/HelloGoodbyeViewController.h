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
    NSString * _labelPrefix;
    NSString * _labelInfix;
}

@property (retain) IBOutlet UILabel *label;
@property (copy) NSString *pendingOperation;
@property (nonatomic, copy) NSString * currentDigits;
@property (nonatomic, copy) NSString * previousDigits;
@property (nonatomic, copy) NSString * labelPrefix;
@property (nonatomic, copy) NSString * labelInfix;
@property (readonly) double currentOperand;
@property (readonly) double previousOperand;

- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)cleanAll;

@end
