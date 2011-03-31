//
//  HelloGoodbyeViewController_iPhone.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseViewController_iPhone.h"


@implementation AllYourBaseViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(AllYourBaseModel *)model
{
    self = [super initWithNibName:@"AllYourBaseViewController_iPhone" bundle:nil model:nil];;
    if (self)
    {
        self.model = [[[AllYourBaseModel alloc] init] autorelease];
        for (NSString *name in [NSArray arrayWithObjects:
                          @"previousDisplay", @"currentDisplay",
                          @"previousDigits", @"currentDigits",
                          @"previousOperation", @"currentOperation",
                          @"previousExpression", @"result",
                          nil]) {
            [self.model addObserver:self forKeyPath:name options:NSKeyValueObservingOptionNew context:nil];
        }
        self.isShowingLandscapeView = NO;
        self.landscapeViewController = [[[AllYourBaseViewController_iPhoneL alloc]
                                         initWithNibName:@"AllYourBaseViewController_iPhoneL"
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
    }
}

@end
