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
    AllYourBaseModel *_model;
    UILabel *_label;
}

@property (retain) AllYourBaseViewController *landscapeViewController;
@property BOOL isShowingLandscapeView;

@property (retain) AllYourBaseModel *model;
@property (retain) IBOutlet UILabel *label;
@property (retain) IBOutlet UILabel *pendingLabel, *currentLabel, *previousLabel;

- (void)updateLabel;
- (void)releaseMembers;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(AllYourBaseModel *)model;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)resultPressed:(UIButton *)sender;
- (IBAction)cleanAll;

@end
