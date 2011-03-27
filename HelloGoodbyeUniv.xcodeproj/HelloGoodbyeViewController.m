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
@synthesize operationHasJustBeenPerformed = _operationHasJustBeenPerformed;

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
    NSString *prefix;
    if (self.operationHasJustBeenPerformed) {
        prefix = @"=";
    } else {
        prefix = @"";
    }
    if (self.previousDigits) {
        self.label.text = [NSString stringWithFormat:
            @"%@%@%@%@"
            , prefix
            , self.previousDigits
            , self.pendingOperation ? self.pendingOperation : @""
            , self.currentDigits ? self.currentDigits : @""
       ];
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
    return [NSString stringWithFormat:@"%g", result];
}

- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operation = sender.titleLabel.text;
    NSLog(@"%@ operation pressed", operation);
    if (self.pendingOperation) {
        NSString *resultDigits = [self performPendingOperation];
        if ([operation isEqualToString:@"="]) {
            self.pendingOperation = nil;
        } else {
            self.pendingOperation = operation;
        }
        self.previousDigits = resultDigits;
        self.currentDigits = @"";
        self.operationHasJustBeenPerformed = YES;
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
    // TODO: check for repeated decimal points
    NSString *digit = sender.titleLabel.text;
    NSLog(@"%@ digit pressed", digit);
    if ([self.currentDigits isEqualToString:@"0"]) {
        self.currentDigits = digit;
    } else {
        self.currentDigits = [self.currentDigits stringByAppendingString:digit];
    }
    self.operationHasJustBeenPerformed = NO;
    [self updateLabel];
}

- (IBAction)cleanAll
{
    NSLog(@"clean button pressed");
    self.pendingOperation = nil;
    self.previousDigits = nil;
    self.currentDigits = @"0";
    self.label.text = @"0";
    self.operationHasJustBeenPerformed = NO;
    [self updateLabel];
}

- (void)releaseMembers
{
    self.pendingOperation = nil;
    self.previousDigits = nil;
    self.currentDigits = nil;
    self.label = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentDigits = @"";
        self.operationHasJustBeenPerformed = NO;
    }
    return self;
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
