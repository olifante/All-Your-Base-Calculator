//
//  HelloGoodbyeViewController.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseViewController.h"

const unichar plus = 0x002b;        // + PLUS SIGN
const unichar minus = 0x2212;       // − MINUS SIGN
const unichar times = 0x00d7;       // × MULTIPLICATION SIGN
const unichar divide = 0x00f7;      // ÷ DIVISION SIGN
const unichar power = 0x2191;       // ↑ UPWARDS ARROW
//const unichar point = 0x2027;       // ‧ HYPHENATION POINT
const unichar point = 0x2219;       // ∙ BULLET OPERATOR
const unichar negate = 0x2213;      // ∓ MINUS-OR-PLUS SIGN
const unichar negative = 0x002d;    // - HYPHEN-MINUS
//const unichar negative = 0xfe63;    // ﹣ SMALL HYPHEN-MINUS
//const unichar negative = 0x02d7;    // ˗ MODIFIER LETTER MINUS SIGN

@implementation AllYourBaseViewController

@synthesize portraitView;
@synthesize landscapeView;
@synthesize isShowingLandscapeView;
@synthesize model;
@synthesize base;

# pragma mark outlets

@synthesize previousDisplayLabel, currentDisplayLabel;
@synthesize previousDisplayLabelLandscape, currentDisplayLabelLandscape;

# pragma mark release method

- (void)releaseMembers
{
    self.previousDisplayLabel = nil;
    self.currentDisplayLabel = nil;
    self.previousDisplayLabelLandscape = nil;
    self.currentDisplayLabelLandscape = nil;
        
    self.model = nil;
    self.landscapeView = nil;
    self.portraitView = nil;
}

# pragma mark NSObject overridden methods

- (void)dealloc
{
    [self releaseMembers];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%@ saw keypath %@", self, keyPath);
    [self updateLabels];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"base %02d %@ controller"
            , self.base
            , self.isShowingLandscapeView? @"landscape" : @"portrait"
            ];
}
    
# pragma mark UIViewController overridden methods

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    int modelBase = self.model.base;
    int controllerBase = self.base;
    if (modelBase != controllerBase) {
        self.model.base = controllerBase;
    }
    
    for (NSString *name in [NSArray arrayWithObjects:
                            @"mainDisplay", @"secondaryDisplay",
                            nil]) {
        [self.model addObserver:self forKeyPath:name options:NSKeyValueObservingOptionNew context:nil];
    }
    
    [self updateLabels];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    for (NSString *name in [NSArray arrayWithObjects:
                            @"mainDisplay", @"secondaryDisplay",
                            nil]) {
        [self.model removeObserver:self forKeyPath:name];
    }    
}

- (void)viewDidUnload {

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil model:nil];
    return self;
}

# pragma mark own initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(AllYourBaseModel *)theModel
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        self.base = 10;
        
        if (theModel) {
            self.model = theModel;
        } else
        {
            self.model = [[[AllYourBaseModel alloc] init] autorelease];
        }

        self.isShowingLandscapeView = NO;
        [self.view addSubview:self.portraitView];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(orientationChanged:)
         name:UIDeviceOrientationDidChangeNotification
         object:nil];

    }
    return self;
}

# pragma mark instance methods

- (void)updateLabels
{
    NSString *secondaryText = self.model.secondaryDisplay;
    NSString *primaryText = self.model.mainDisplay;
    
    NSDictionary *operations = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"+", [NSString stringWithFormat:@"%C", plus],
                           @"-", [NSString stringWithFormat:@"%C", minus],
                           @"*", [NSString stringWithFormat:@"%C", times],
                           @"/", [NSString stringWithFormat:@"%C", divide],
                           @"^", [NSString stringWithFormat:@"%C", power],
                           nil];
    
    NSString *ASCIIOperation = @"";
    for (NSString *unicodeOperation in operations) {
        ASCIIOperation = [operations objectForKey:unicodeOperation];
        secondaryText = [secondaryText stringByReplacingOccurrencesOfString:ASCIIOperation withString:unicodeOperation];
        primaryText = [primaryText stringByReplacingOccurrencesOfString:ASCIIOperation withString:unicodeOperation];
    }
    self.previousDisplayLabel.text = secondaryText;
    self.currentDisplayLabel.text = primaryText;
    
    self.previousDisplayLabelLandscape.text = secondaryText;
    self.currentDisplayLabelLandscape.text = primaryText;
}

# pragma mark actions

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    NSLog(@"%@ '%@' digit pressed", self, digit);
    if ([digit isEqualToString:[self pointString]]) {
        [self.model digitPressed:@"."];
    } else {
        [self.model digitPressed:digit];
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operation = sender.titleLabel.text;
    NSLog(@"%@ '%@' operation pressed", self, operation);
    if ([operation isEqualToString:[self plusString]]) {
        [self.model binaryOperationPressed:@"+"];
    } else if ([operation isEqualToString:[self minusString]]) {
        [self.model binaryOperationPressed:@"-"];
    } else if ([operation isEqualToString:[self timesString]]) {
        [self.model binaryOperationPressed:@"*"];
    } else if ([operation isEqualToString:[self divideString]]) {
        [self.model binaryOperationPressed:@"/"];
    } else if ([operation isEqualToString:[self powerString]]) {
        [self.model binaryOperationPressed:@"^"];
    } else {
        [self.model binaryOperationPressed:operation];
    }
}

- (IBAction)resultPressed
{
    NSLog(@"%@ '=' pressed", self);
    [self.model resultPressed];
}

- (IBAction)deletePressed
{
    NSLog(@"%@ delete pressed", self);
    [self.model deletePressed];
}

- (IBAction)cleanPressed
{
    NSLog(@"%@ clean pressed", self);
    [self.model cleanPressed];
}

- (IBAction)reciprocalPressed
{
    NSLog(@"%@ 'INV' pressed", self);
    [self.model binaryOperationPressed:@"^"];
    [self.model negatePressed];
    [self.model digitPressed:@"1"];    
}

- (IBAction)negatePressed
{
    NSLog(@"%@ 'NEG' pressed", self);
    [self.model negatePressed];
}

- (IBAction)squareRootPressed
{
    NSLog(@"%@ 'SQRT' pressed", self);
    [self.model binaryOperationPressed:@"^"];
    [self.model digitPressed:@"."];
    [self.model digitPressed:@"5"];
    [self.model resultPressed];
}

- (IBAction)cubeRootPressed
{
    NSLog(@"%@ 'CBRT' pressed", self);
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
- (NSString *)powerString { return [NSString stringWithFormat:@"%C", power]; }
- (NSString *)negateString { return [NSString stringWithFormat:@"%C", negate]; }
- (NSString *)negativeString { return [NSString stringWithFormat:@"%C", negative]; }
- (NSString *)pointString { return [NSString stringWithFormat:@"%C", point]; }

- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) && !self.isShowingLandscapeView)
    {
        [self.portraitView removeFromSuperview];
        [self.view addSubview:self.landscapeView];
//        self.landscapeView.frame = self.view.bounds;
        self.isShowingLandscapeView = YES;
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) && self.isShowingLandscapeView)
    {
        [self.landscapeView removeFromSuperview];
        [self.view addSubview:self.portraitView];
//        self.portraitView.frame = self.view.bounds;
        self.isShowingLandscapeView = NO;
    }
}
@end
