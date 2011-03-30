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
@synthesize currentLabel, previousLabel;

- (void)updateLabels
{
    self.currentLabel.text = self.model.currentDisplay;
    self.previousLabel.text = self.model.previousDisplay;
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
    } else if (!self.model.currentDigits && [digit isEqualToString:@"."]) {
        self.model.currentDigits = @"0."; // keep initial zero if period pressed
    } else {
        self.model.currentDigits = digit;
    }
    self.model.operationHasJustBeenPerformed = NO;
    [self updateLabels];
}

- (IBAction)periodPressed:(UIButton *)sender
{
    unichar period = [@"." characterAtIndex:0];
    for (int i = 0; i < self.model.currentDigits.length; i++) {
        if ([self.model.currentDigits characterAtIndex:i] == period) {
            return; // do nothing if current string contains period
        }
    }
    return [self digitPressed:sender];
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
    [self updateLabels];
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
    [self updateLabels];
}

- (IBAction)cleanAll
{
    NSLog(@"clean button pressed");
    [self.model releaseMembers];
    [self updateLabels];
}

- (void)releaseMembers
{
    self.currentLabel = nil;
    self.previousLabel = nil;
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
    [self updateLabels];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"observed keyPath:%@", keyPath);
    if ([keyPath isEqualToString:@"previousDigits"] || [keyPath isEqualToString:@"currentDigits"]) {
        [self updateLabels];
    }
}

@end
