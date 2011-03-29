//
//  HelloGoodbyeViewController_iPad.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseViewController_iPad.h"


@implementation AllYourBaseViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(AllYourBaseModel *)model
{
    self = [super initWithNibName:@"AllYourBaseViewController_iPad" bundle:nil model:nil];;
    if (self)
    {
        self.model = [[[AllYourBaseModel alloc] init] autorelease];
        self.isShowingLandscapeView = NO;
        self.landscapeViewController = [[[AllYourBaseViewController_iPadL alloc]
                                         initWithNibName:@"AllYourBaseViewController_iPadL"
                                         bundle:nil
                                         model:self.model] autorelease];
        
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
    if (UIDeviceOrientationIsLandscape(deviceOrientation) &&
        !self.isShowingLandscapeView)
    {
        [self presentModalViewController:self.landscapeViewController
                                animated:NO];
        self.isShowingLandscapeView = YES;
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) &&
             self.isShowingLandscapeView)
    {
        [self dismissModalViewControllerAnimated:NO];
        self.isShowingLandscapeView = NO;
        [self updateLabels];
    }
}

@end
