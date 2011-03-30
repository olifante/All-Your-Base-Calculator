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
    NSLog(@"%@ observed keyPath:%@", [self class], keyPath);
    if ([keyPath isEqualToString:@"previousDigits"] || [keyPath isEqualToString:@"currentDigits"]) {
        [self updateLabels];
    }
}

@end
