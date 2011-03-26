//
//  HelloGoodbyeViewController.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "HelloGoodbyeViewController.h"


@implementation HelloGoodbyeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.previousOperand = 0;
        self.currentOperand = 0;
        self.operationPending = nil;
    }
    return self;
}

@synthesize previousOperand = _previousOperand;
@synthesize operationPending = _operationPending;
@synthesize label = _label;

- (void)setCurrentOperand:(double)operand
{
    _currentOperand = operand;
    NSString *newText;
    if (operand != 0) {
        newText = [NSString stringWithFormat:@"%f", operand];
    } else {
        newText = @"0";
    }
    self.label.text = newText;
}

- (double)currentOperand
{
    return _currentOperand;
}

- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operation = sender.titleLabel.text;
    NSLog(@"%@ operation pressed", operation);
    if (self.operationPending) {
        self.currentOperand = self.previousOperand + self.currentOperand;
        self.operationPending = operation;
    } else {
        self.previousOperand = self.currentOperand;
        self.currentOperand = 0;
        self.operationPending = operation;
    }
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    NSLog(@"%@ digit pressed", digit);
    if (self.currentOperand != 0) {
        self.currentOperand = [[self.label.text stringByAppendingString:digit] doubleValue];
    } else {
        self.currentOperand = [digit doubleValue];
    }
}

- (IBAction)cleanAll
{
    NSLog(@"clean button pressed");
    self.currentOperand = 0;
    self.previousOperand = 0;
    self.operationPending = nil;
}

- (void)releaseMembers
{
    self.operationPending = nil;
    self.label = nil;
}
- (void)dealloc
{
    [self releaseMembers];
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.label.text = @"0";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseMembers];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}
@end
