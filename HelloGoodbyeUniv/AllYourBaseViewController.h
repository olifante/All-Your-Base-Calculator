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

@interface AllYourBaseViewController : UIViewController {
}

@property(nonatomic,retain) IBOutlet UIView *portraitView;
@property(nonatomic,retain) IBOutlet UIView *landscapeView;
@property BOOL isShowingLandscapeView;
@property (retain) AllYourBaseModel *model;

@property (retain) IBOutlet UILabel *previousDisplayLabel, *currentDisplayLabel;
@property (retain) IBOutlet UILabel *previousDisplayLabelLandscape, *currentDisplayLabelLandscape;

- (void)releaseMembers;

- (void)dealloc;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

- (void)viewDidUnload;
- (void)viewDidLoad;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(AllYourBaseModel *)model;

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
- (NSString *)negateString;
- (NSString *)negativeString;
- (NSString *)pointString;

- (void)orientationChanged:(NSNotification *)notification;
@end
