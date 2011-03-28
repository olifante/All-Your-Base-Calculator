//
//  HelloGoodbyeViewController.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "HelloGoodbyeViewController.h"


@implementation HelloGoodbyeViewController

@synthesize landscapeViewController;
@synthesize isShowingLandscapeView;

@synthesize label = _label;
@synthesize pendingLabel, currentLabel, previousLabel;
@synthesize pendingOperation = _pendingOperation;
@synthesize currentDigits = _currentDigits;
@synthesize previousDigits = _previousDigits;
@synthesize operationHasJustBeenPerformed = _operationHasJustBeenPerformed;

- (void)setCurrentDigits:(NSString *)digits
{
    [_currentDigits release];
    _currentDigits = digits;
    [_currentDigits retain];    
    self.currentLabel.text = digits;
}

- (void)setPreviousDigits:(NSString *)digits
{
    [_previousDigits release];
    _previousDigits = digits;
    [_previousDigits retain];
    self.previousLabel.text = digits;
}

- (void)setPendingOperation:(NSString *)pendingOperation
{
    [_pendingOperation release];
    _pendingOperation = pendingOperation;
    [_pendingOperation retain];
    self.pendingLabel.text = pendingOperation;
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
    if (self.operationHasJustBeenPerformed && self.previousDigits && self.pendingOperation) {
        self.label.text = [NSString stringWithFormat:
                           @"= %@ %@ %@"
                           , self.previousDigits
                           , self.pendingOperation
                           , self.currentDigits ? self.currentDigits : @""
                           ];
    } else if (self.operationHasJustBeenPerformed && self.previousDigits && !self.pendingOperation) {
        self.label.text = [NSString stringWithFormat:
                           @"= %@"
                           , self.previousDigits
                           ];
    } else if (!self.operationHasJustBeenPerformed && self.previousDigits && self.pendingOperation) {
        self.label.text = [NSString stringWithFormat:
                           @"%@ %@ %@"
                           , self.previousDigits
                           , self.pendingOperation
                           , self.currentDigits ? self.currentDigits : @""
                           ];
    } else {
        self.label.text = self.currentDigits;
    }
}
- (void)performPendingOperation
{
    double result;
    BOOL success = YES;
    if ([self.pendingOperation isEqualToString:@"+"]) {
        result = self.previousOperand + self.currentOperand;
    } else if ([self.pendingOperation isEqualToString:@"-"]) {
        result = self.previousOperand - self.currentOperand;
    } else if ([self.pendingOperation isEqualToString:@"*"]) {
        result = self.previousOperand * self.currentOperand;
    } else if ([self.pendingOperation isEqualToString:@"/"]) {
        result = self.previousOperand / self.currentOperand;
    } else {
        success = NO;
    }
    if (success) {
        self.previousDigits = [NSString stringWithFormat:@"%g", result];
        self.pendingOperation = nil;
        self.currentDigits = nil;
        self.operationHasJustBeenPerformed = YES;
    }
}

- (IBAction)digitPressed:(UIButton *)sender
{
    // TODO: check for repeated decimal points
    NSString *digit = sender.titleLabel.text;
    NSLog(@"%@ digit pressed", digit);
    if (!self.pendingOperation && self.previousDigits) {
        [self cleanAll]; // if there is no pending operation we don't want stale values lying around
    }
    if (self.currentDigits) {
        self.currentDigits = [self.currentDigits stringByAppendingString:digit];
    } else if ([digit isEqualToString:@"0"]) {
        // do not add a zero if there are no current digits
    } else {
        self.currentDigits = digit;
    }
    self.operationHasJustBeenPerformed = NO;
    [self updateLabel];
}

- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operation = sender.titleLabel.text;
    NSLog(@"%@ operation pressed", operation);
    if (!self.currentDigits && self.pendingOperation) {
        // do nothing if 2nd operation pressed with an empty 2nd operand
    } else if (self.pendingOperation) {
        [self performPendingOperation];
        self.pendingOperation = operation;
    } else { // no pending operation
        if (!self.operationHasJustBeenPerformed) {
            // if no operation has just been performed, the 1st operand is empty
            self.previousDigits = self.currentDigits;
        }
        self.pendingOperation = operation;
        self.currentDigits = nil;
    }
    [self updateLabel];
}

- (IBAction)resultPressed:(UIButton *)sender
{
    NSLog(@"results button pressed");
    if (self.currentDigits && self.pendingOperation) {
        [self performPendingOperation];
    } else if (self.pendingOperation) { // but no 2nd operand
        self.pendingOperation = nil;
    } else if (self.previousDigits) {
        self.previousDigits = [NSString stringWithFormat:@"%g", self.previousOperand];
    } else {
        self.previousDigits = [NSString stringWithFormat:@"%g", self.currentOperand];
    }
    self.currentDigits = nil;
    self.operationHasJustBeenPerformed = YES;
    [self updateLabel];
    
}

- (IBAction)cleanAll
{
    NSLog(@"clean button pressed");
    self.pendingOperation = nil;
    self.previousDigits = nil;
    self.currentDigits = nil;
    self.label.text = @"0";
    self.operationHasJustBeenPerformed = NO;
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
        [self cleanAll];
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
