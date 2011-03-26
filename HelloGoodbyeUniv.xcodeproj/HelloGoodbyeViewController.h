//
//  HelloGoodbyeViewController.h
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelloGoodbyeViewController : UIViewController {
    double _currentOperand;
    double _previousOperand;
    NSString * _operationPending;
    UILabel * _label;
}

@property double currentOperand;
@property double previousOperand;
@property (retain) NSString *operationPending;
@property (retain) IBOutlet UILabel *label;

- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)cleanAll;

@end
