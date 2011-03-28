//
//  HelloGoodbyeViewController_iPhone.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "HelloGoodbyeViewController_iPhone.h"


@implementation HelloGoodbyeViewController_iPhone

@synthesize landscapeViewController;
@synthesize isShowingLandscapeView;

- (id)init
{
    self = [super initWithNibName:@"HelloGoodbyeViewController_iPhone" bundle:nil];;
    if (self)
    {
        isShowingLandscapeView = NO;
        self.landscapeViewController = [[[HelloGoodbyeViewController_iPhoneL alloc]
                                         initWithNibName:@"HelloGoodbyeViewController_iPhoneL"
                                         bundle:nil] autorelease];
        
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
        !isShowingLandscapeView)
    {
        [self presentModalViewController:self.landscapeViewController
                                animated:YES];
        isShowingLandscapeView = YES;
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) &&
             isShowingLandscapeView)
    {
        [self dismissModalViewControllerAnimated:YES];
        isShowingLandscapeView = NO;
    }
}

@end
