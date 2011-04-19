//
//  HelloGoodbyeViewController_iPhone.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseViewController_iPhone.h"


@implementation AllYourBaseViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(AllYourBaseModel *)theModel
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil model:theModel];;
    if (self) {
        self.isShowingLandscapeView = NO;
        [self.view addSubview:self.portraitView];
        self.portraitView.frame = self.view.bounds;
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) && !self.isShowingLandscapeView)
    {
        [self.portraitView removeFromSuperview];
        [self.view addSubview:self.landscapeView];
        self.landscapeView.frame = self.view.bounds;
        self.isShowingLandscapeView = YES;
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) && self.isShowingLandscapeView)
    {
        [self.landscapeView removeFromSuperview];
        [self.view addSubview:self.portraitView];
        self.portraitView.frame = self.view.bounds;
        self.isShowingLandscapeView = NO;
    }
}

@end
