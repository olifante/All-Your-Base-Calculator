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
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil model:theModel];
    return self;
}

- (id)initWithModel:(AllYourBaseModel *)theModel base:(int)someBase
{
    if (!someBase || (someBase < 2) || (someBase > 100)) {
        NSLog(@"only bases from 2 to 100 are supported");
        return nil; // early return because it's useless to invoke [self init]
    }
    
    NSString *nibPrefix = @"AllYourBaseViewController_iPad";
    NSString *nibForBase = [NSString stringWithFormat:@"%@%02d", nibPrefix, someBase];
    
    self = [self initWithNibName:nibForBase bundle:nil model:theModel];
    if (self) {
        self.base = someBase;
        self.title = [NSString stringWithFormat:@"Base %d", someBase];
        self.isShowingLandscapeView = NO;
        [self.view addSubview:self.portraitView];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

@end
