//
//  HelloGoodbyeViewController_iPhoneL.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/28/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseViewController_iPhoneL.h"


@implementation AllYourBaseViewController_iPhoneL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(AllYourBaseModel *)model
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil model:nil];;
    if (self) {
        self.model = model;
        [self.model addObserver:self forKeyPath:@"currentDigits" options:NSKeyValueObservingOptionNew context:nil];
        [self.model addObserver:self forKeyPath:@"previousDigits" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end