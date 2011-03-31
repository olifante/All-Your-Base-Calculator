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
@synthesize firstLabel, secondLabel;
@synthesize firstOperand, secondOperand, currentOperand, pendingOperation, performedOperation, performedExpression, result;

-(void)updateLabels
{
    self.firstLabel.text = self.model.firstDisplay;
    self.secondLabel.text = self.model.secondDisplay;
    
    self.firstOperand.text = self.model.firstOperand;
    self.secondOperand.text = self.model.secondOperand;
    self.currentOperand.text = self.model.currentOperand;
    self.pendingOperation.text = self.model.pendingOperation;
    self.performedOperation.text = self.model.performedOperation;
    self.performedExpression.text = self.model.performedExpression;
    self.result.text = self.model.result;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    NSLog(@"%@ digit pressed", digit);
    [self.model digitPressed:digit];
}

- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operation = sender.titleLabel.text;
    NSLog(@"%@ operation pressed", operation);
    [self.model operationPressed:operation];
}

- (IBAction)periodPressed
{
    [self.model periodPressed];
}

- (IBAction)resultPressed
{
    NSLog(@"results button pressed");
    [self.model resultPressed];
}

- (IBAction)cleanPressed
{
    NSLog(@"clean button pressed");
    [self.model releaseMembers];
}

- (void)releaseMembers
{
    self.firstLabel = nil;
    self.secondLabel = nil;
    
    self.firstOperand = nil;
    self.secondOperand = nil;
    self.currentOperand = nil;
    self.pendingOperation = nil;
    self.performedOperation = nil;
    self.performedExpression = nil;
    self.result = nil;
    
    self.model = nil;
    self.landscapeViewController = nil;
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%@ observed keyPath:%@", [self class], keyPath);
    [self updateLabels];
}

@end
