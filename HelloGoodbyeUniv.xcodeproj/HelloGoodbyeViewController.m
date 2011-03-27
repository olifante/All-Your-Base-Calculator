//
//  HelloGoodbyeViewController.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "HelloGoodbyeViewController.h"


@implementation HelloGoodbyeViewController

@synthesize label = _label;
@synthesize pendingOperation = _pendingOperation;
@synthesize currentDigits = _currentDigits;
@synthesize previousDigits = _previousDigits;
@synthesize labelPrefix = _labelPrefix;
@synthesize labelInfix = _labelInfix;

- (NSString *)currentDigits
{
    if (!_currentDigits) {
        _currentDigits = @"";
    }
    return _currentDigits;
}

- (double)currentOperand
{
    return [self.currentDigits doubleValue];
}

- (double)previousOperand
{
    return [self.previousDigits doubleValue];
}

- (void)updateLabel
{
    if (self.previousDigits && self.pendingOperation) {
        self.label.text = [NSString stringWithFormat:@"%@%@%@", self.previousDigits, self.pendingOperation, self.currentDigits];
    } else if (self.previousDigits && [self.currentDigits isEqualToString:@""]) { // and no pending operation
        self.label.text = [NSString stringWithFormat:@"=%@", self.previousDigits];
    } else {
        self.label.text = self.currentDigits;
    }
}
- (NSString *)performPendingOperation
{
    double result;
    if ([self.pendingOperation isEqualToString:@"+"]) {
        result = self.previousOperand + self.currentOperand;
    } else if ([self.pendingOperation isEqualToString:@"-"]) {
        result = self.previousOperand - self.currentOperand;
    } else if ([self.pendingOperation isEqualToString:@"*"]) {
        result = self.previousOperand * self.currentOperand;
    } else if ([self.pendingOperation isEqualToString:@"/"]) {
        result = self.previousOperand / self.currentOperand;
    }
    return [NSString stringWithFormat:@"%f", result];
}

- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operation = sender.titleLabel.text;
    NSLog(@"%@ operation pressed", operation);
    if ([self.currentDigits isEqualToString:@""] && self.previousDigits) {
        self.currentDigits = self.previousDigits;
    }
    if (self.pendingOperation) {
        NSString *resultDigits = [self performPendingOperation];
        if ([operation isEqualToString:@"="]) {
            self.pendingOperation = nil;
        } else {
            self.pendingOperation = operation;
        }
        self.previousDigits = resultDigits;
        self.currentDigits = @"";
    } else { 
        // no operation pending
        if ([operation isEqualToString:@"="]) {
            // do nothing
        } else {
            self.previousDigits = self.currentDigits;
            self.pendingOperation = operation;
            self.currentDigits = @"";
        }
    }
    [self updateLabel];
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    NSLog(@"%@ digit pressed", digit);
    if ([self.currentDigits isEqualToString:@"0"]) {
        self.currentDigits = digit;
    } else {
        self.currentDigits = [self.currentDigits stringByAppendingString:digit];
    }
    [self updateLabel];
}

- (IBAction)cleanAll
{
    NSLog(@"clean button pressed");
    self.pendingOperation = nil;
    self.previousDigits = nil;
    self.currentDigits = @"0";
    [self updateLabel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentDigits = @"";
    }
    return self;
}

- (void)releaseMembers
{
    self.pendingOperation = nil;
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
    return YES;
}
@end
