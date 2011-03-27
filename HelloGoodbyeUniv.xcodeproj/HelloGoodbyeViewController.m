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
@synthesize previousDigits = _previousDigits;

- (void)setCurrentDigits:(NSString *)currentDigits
{
    _currentDigits = currentDigits;
    if (self.pendingOperation) {
        self.label.text = [NSString stringWithFormat:@"%@ %@ %@", self.previousDigits, self.pendingOperation, self.currentDigits];
    } else {
        self.label.text = currentDigits;
    }
}

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
    if (self.pendingOperation) {
        NSString *resultDigits;
        if ([operation isEqualToString:@"="]) {
            resultDigits = [self performPendingOperation];
            self.previousDigits = nil;
            self.pendingOperation = nil;
            self.currentDigits = resultDigits;
        } else {
            resultDigits = [self performPendingOperation];
            self.previousDigits = resultDigits;
            self.pendingOperation = operation;
            self.currentDigits = @"";
        }
    } else { 
        // no operation pending
        if ([operation isEqualToString:@"="]) {
            // do nothing
            self.previousDigits = nil; // shouldn't be necessary
        } else {
            self.previousDigits = self.currentDigits;
            self.pendingOperation = operation;
            self.currentDigits = @"";
        }
    }
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
}

- (IBAction)cleanAll
{
    NSLog(@"clean button pressed");
    self.currentDigits = @"0";
    self.previousDigits = nil;
    self.pendingOperation = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    // Return YES for supported orientations
    return YES;
}
@end
