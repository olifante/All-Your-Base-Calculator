//
//  HelloGoodbyeViewController_iPad.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseViewController_iPad.h"


@implementation AllYourBaseViewController_iPad

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

@end
