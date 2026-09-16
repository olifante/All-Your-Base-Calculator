//
//  HelloGoodbyeViewController.h
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKString.h"
#import "AllYourBaseModel.h"

@interface AllYourBaseViewController : UIViewController

@property (nonatomic) int base;

@property (nonatomic, strong) IBOutlet UIView *portraitView;
@property (nonatomic, strong) IBOutlet UIView *landscapeView;
@property (nonatomic) BOOL isShowingLandscapeView;
@property (nonatomic, strong) AllYourBaseModel *model;

@property (nonatomic, strong) IBOutlet UILabel *previousDisplayLabel, *currentDisplayLabel;
@property (nonatomic, strong) IBOutlet UILabel *previousDisplayLabelLandscape, *currentDisplayLabelLandscape;

- (void)releaseMembers;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

- (void)viewDidAppear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(AllYourBaseModel *)model;

- (void)updateLabels;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)resultPressed;
- (IBAction)deletePressed;
- (IBAction)cleanPressed;
- (IBAction)squareRootPressed;
- (IBAction)cubeRootPressed;
- (IBAction)reciprocalPressed;
- (IBAction)negatePressed;

- (NSString *)plusString;
- (NSString *)minusString;
- (NSString *)timesString;
- (NSString *)divideString;
- (NSString *)powerString;
- (NSString *)negateString;
- (NSString *)negativeString;
- (NSString *)pointString;

- (void)orientationChanged:(NSNotification *)notification;
@end
