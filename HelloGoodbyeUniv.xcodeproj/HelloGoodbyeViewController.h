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
}

@property (retain) IBOutlet UILabel *label;
@property (retain) NSString *pendingOperation;
@property (nonatomic, retain) NSString * currentDigits;
@property (nonatomic, retain) NSString * previousDigits;
@property (readonly) double currentOperand;
@property (readonly) double previousOperand;

- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)cleanAll;

@end
