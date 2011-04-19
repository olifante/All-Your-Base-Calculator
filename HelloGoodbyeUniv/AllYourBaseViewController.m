//
//  HelloGoodbyeViewController.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseViewController.h"

const unichar plus = 0x002b; // + PLUS SIGN
const unichar minus = 0x2212; // − MINUS SIGN
const unichar times = 0x00d7; // × MULTIPLICATION SIGN
const unichar divide = 0x00f7; // ÷ DIVISION SIGN
//const unichar point = 0x2027; // ‧ HYPHENATION POINT
const unichar point = 0x2219; // ∙ BULLET OPERATOR
const unichar negate = 0x2213; // ∓ MINUS-OR-PLUS SIGN
const unichar negative = 0x002d; // - HYPHEN-MINUS
//const unichar negative = 0xfe63; // ﹣ SMALL HYPHEN-MINUS
//const unichar negative = 0x02d7; // ˗ MODIFIER LETTER MINUS SIGN

@implementation AllYourBaseViewController

@synthesize landscapeViewController;
@synthesize isShowingLandscapeView;
@synthesize model;

# pragma mark outlets

@synthesize previousDisplayLabel, currentDisplayLabel;
@synthesize previousDigitsLabel, currentDigitsLabel, currentOperationLabel, previousOperationLabel, previousExpressionLabel, resultLabel;

# pragma mark release method

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

# pragma mark NSObject overridden methods

- (void)dealloc
{
    [self releaseMembers];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%@ observed keyPath:%@", [self class], keyPath);
    [self updateLabels];
}

# pragma mark UIViewController overridden methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (NSString *name in [NSArray arrayWithObjects:
                            @"mainDisplay", @"secondaryDisplay",
                            nil]) {
        [self.model addObserver:self forKeyPath:name options:NSKeyValueObservingOptionNew context:nil];
    }
    
    [self updateLabels];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    for (NSString *name in [NSArray arrayWithObjects:
                            @"mainDisplay", @"secondaryDisplay",
                            nil]) {
        [self.model removeObserver:self forKeyPath:name];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil model:nil];
    return self;
}

# pragma mark own initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(AllYourBaseModel *)theModel
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (theModel) {
            self.model = theModel;
        } else
        {
            self.model = [[[AllYourBaseModel alloc] init] autorelease];
        }
    }
    return self;
}

# pragma mark instance methods

- (void)updateLabels
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

# pragma mark actions

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    NSLog(@"%@ digit pressed", digit);
    if ([digit isEqualToString:[self pointString]]) {
        [self.model digitPressed:@"."];
    } else {
        [self.model digitPressed:digit];
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operation = sender.titleLabel.text;
    NSLog(@"%@ operation pressed", operation);
    if ([operation isEqualToString:[self plusString]]) {
        [self.model binaryOperationPressed:@"+"];
    } else if ([operation isEqualToString:[self minusString]]) {
        [self.model binaryOperationPressed:@"-"];
    } else if ([operation isEqualToString:[self timesString]]) {
        [self.model binaryOperationPressed:@"*"];
    } else if ([operation isEqualToString:[self divideString]]) {
        [self.model binaryOperationPressed:@"/"];
    } else {
        [self.model binaryOperationPressed:operation];
    }
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

# pragma mark symbol accessor methods

- (NSString *)plusString { return [NSString stringWithFormat:@"%C", plus]; }
- (NSString *)minusString { return [NSString stringWithFormat:@"%C", minus]; }
- (NSString *)timesString { return [NSString stringWithFormat:@"%C", times]; }
- (NSString *)divideString { return [NSString stringWithFormat:@"%C", divide]; }
- (NSString *)negateString { return [NSString stringWithFormat:@"%C", negate]; }
- (NSString *)negativeString { return [NSString stringWithFormat:@"%C", negative]; }
- (NSString *)pointString { return [NSString stringWithFormat:@"%C", point]; }

@end
