//
//  HelloGoodbyeViewController.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseViewController.h"


@implementation AllYourBaseViewController

@synthesize landscapeViewController;
@synthesize isShowingLandscapeView;

@synthesize model;
@synthesize label = _label;
@synthesize pendingLabel, currentLabel, previousLabel;

- (void)updateLabel
{
    if (self.model.operationHasJustBeenPerformed && self.model.previousDigits && self.model.pendingOperation) {
        self.label.text = [NSString stringWithFormat:
                           @"= %@ %@ %@"
                           , self.model.previousDigits
                           , self.model.pendingOperation
                           , self.model.currentDigits ? self.model.currentDigits : @""
                           ];
    } else if (self.model.operationHasJustBeenPerformed && self.model.previousDigits && !self.model.pendingOperation) {
        self.label.text = [NSString stringWithFormat:
                           @"= %@"
                           , self.model.previousDigits
                           ];
    } else if (!self.model.operationHasJustBeenPerformed && self.model.previousDigits && self.model.pendingOperation) {
        self.label.text = [NSString stringWithFormat:
                           @"%@ %@ %@"
                           , self.model.previousDigits
                           , self.model.pendingOperation
                           , self.model.currentDigits ? self.model.currentDigits : @""
                           ];
    } else {
        self.label.text = self.model.currentDigits;
    }
}

- (IBAction)digitPressed:(UIButton *)sender
{
    // TODO: check for repeated decimal points
    NSString *digit = sender.titleLabel.text;
    NSLog(@"%@ digit pressed", digit);
    if (!self.model.pendingOperation && self.model.previousDigits) {
        [self cleanAll]; // if there is no pending operation we don't want stale values lying around
    }
    if (self.model.currentDigits) {
        self.model.currentDigits = [self.model.currentDigits stringByAppendingString:digit];
    } else if ([digit isEqualToString:@"0"]) {
        // do not add a zero if there are no current digits
    } else {
        self.model.currentDigits = digit;
    }
    self.model.operationHasJustBeenPerformed = NO;
    [self updateLabel];
}

- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operation = sender.titleLabel.text;
    NSLog(@"%@ operation pressed", operation);
    if (!self.model.currentDigits && self.model.pendingOperation) {
        // do nothing if 2nd operation pressed with an empty 2nd operand
    } else if (self.model.pendingOperation) {
        [self.model performPendingOperation];
        self.model.pendingOperation = operation;
    } else { // no pending operation
        if (!self.model.operationHasJustBeenPerformed) {
            // if no operation has just been performed, the 1st operand is empty
            self.model.previousDigits = self.model.currentDigits;
        }
        self.model.pendingOperation = operation;
        self.model.currentDigits = nil;
    }
    [self updateLabel];
}

- (IBAction)resultPressed:(UIButton *)sender
{
    NSLog(@"results button pressed");
    if (self.model.currentDigits && self.model.pendingOperation) {
        [self.model performPendingOperation];
    } else if (self.model.pendingOperation) { // but no 2nd operand
        self.model.pendingOperation = nil;
    } else if (self.model.previousDigits) {
        self.model.previousDigits = [NSString stringWithFormat:@"%g", self.model.previousOperand];
    } else {
        self.model.previousDigits = [NSString stringWithFormat:@"%g", self.model.currentOperand];
    }
    self.model.currentDigits = nil;
    self.model.operationHasJustBeenPerformed = YES;
    [self updateLabel];
    
}

- (IBAction)cleanAll
{
    NSLog(@"clean button pressed");
    [self.model releaseMembers];
    [self updateLabel];
}

- (void)releaseMembers
{
    self.label = nil;
    self.model = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil model:nil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(AllYourBaseModel *)model
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // initialization code
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
    [self updateLabel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseMembers];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
