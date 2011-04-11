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
@synthesize previousDisplayLabel, currentDisplayLabel;
@synthesize previousDigitsLabel, currentDigitsLabel, currentOperationLabel, previousOperationLabel, previousExpressionLabel, resultLabel;

-(void)updateLabels
{
    self.previousDisplayLabel.text = self.model.secondaryDisplay;
    self.currentDisplayLabel.text = self.model.mainDisplay;
    
    self.previousDigitsLabel.text = self.model.previousDigits.signedDigits;
    self.currentDigitsLabel.text = self.model.currentDigits.signedDigits;
    self.currentOperationLabel.text = self.model.currentOperation;
    self.previousOperationLabel.text = self.model.previousOperation;
    self.previousExpressionLabel.text = self.model.previousExpression;
    self.resultLabel.text = self.model.resultDigits.signedDigits;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    NSLog(@"%@ digit pressed", digit);
    if ([digit isEqualToString:@"∙"]) {
        [self.model digitPressed:@"."];
    } else {
        [self.model digitPressed:digit];
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operation = sender.titleLabel.text;
    NSLog(@"%@ operation pressed", operation);
    [self.model binaryOperationPressed:operation];
}

- (IBAction)resultPressed
{
    NSLog(@"result button pressed");
    [self.model resultPressed];
}

- (IBAction)deletePressed
{
    NSLog(@"delete button pressed");
    [self.model deletePressed];
}

- (IBAction)cleanPressed
{
    NSLog(@"clean button pressed");
    [self.model cleanPressed];
}

- (IBAction)reciprocalPressed
{
    NSLog(@"reciprocal button pressed");
    [self.model binaryOperationPressed:@"^"];
    [self.model negatePressed];
    [self.model digitPressed:@"1"];    
}

- (IBAction)negatePressed
{
    NSLog(@"negate button pressed");
    [self.model negatePressed];
}

- (IBAction)squareRootPressed
{
    NSLog(@"square root button pressed");
    [self.model binaryOperationPressed:@"^"];
    [self.model digitPressed:@"."];
    [self.model digitPressed:@"5"];
    [self.model resultPressed];
}

- (IBAction)cubeRootPressed
{
    NSLog(@"cube root button pressed");
    [self.model binaryOperationPressed:@"^"];
    [self.model digitPressed:@"."];
    [self.model digitPressed:@"3"];
    [self.model digitPressed:@"3"];
    [self.model digitPressed:@"3"];
    [self.model digitPressed:@"3"];
    [self.model digitPressed:@"3"];
    [self.model digitPressed:@"3"];
    [self.model resultPressed];
}

- (void)releaseMembers
{
    self.previousDisplayLabel = nil;
    self.currentDisplayLabel = nil;
    
    self.previousDigitsLabel = nil;
    self.currentDigitsLabel = nil;
    self.currentOperationLabel = nil;
    self.previousOperationLabel = nil;
    self.previousExpressionLabel = nil;
    self.resultLabel = nil;
    
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
