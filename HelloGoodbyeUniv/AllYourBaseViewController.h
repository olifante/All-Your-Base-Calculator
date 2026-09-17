//
//  AllYourBaseViewController.h
//  AllYourBase
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllYourBaseModel.h"

@interface AllYourBaseViewController : UIViewController

@property (nonatomic) int base;
@property (nonatomic, strong) AllYourBaseModel *model;

@property (nonatomic, strong) UILabel *previousDisplayLabel, *currentDisplayLabel;

- (instancetype)initWithModel:(AllYourBaseModel *)model;

- (void)releaseMembers;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

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

@end
