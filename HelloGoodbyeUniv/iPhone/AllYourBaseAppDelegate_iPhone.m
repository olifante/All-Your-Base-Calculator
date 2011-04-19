//
//  HelloGoodbyeUnivAppDelegate_iPhone.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseAppDelegate_iPhone.h"
#import "AllYourBaseViewController_iPhone.h"

@implementation AllYourBaseAppDelegate_iPhone

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    AllYourBaseModel *theModel = [[[AllYourBaseModel alloc] init] autorelease];
    UITabBarController *tbc = [[UITabBarController alloc] init];
    UIViewController *vc1 = [[AllYourBaseViewController_iPhone alloc] 
                             initWithNibName:nil 
                             bundle:nil 
                             model:theModel
                             ];
    UIViewController *vc2 = [[AllYourBaseViewController_iPhoneL alloc] 
                             initWithNibName:@"AllYourBaseViewController_iPhone 2" 
                             bundle:nil 
                             model:theModel
                             ];
    vc1.title = @"view1";
    vc2.title = @"view2";
    tbc.viewControllers = [NSArray arrayWithObjects: vc1, vc2, nil];
    self.tabBarViewController = tbc;
//    self.tabBarViewController = [[AllYourBaseViewController_iPhone alloc] init];
    self.window.rootViewController = self.tabBarViewController;
    [self.window addSubview:self.tabBarViewController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
	[super dealloc];
}

@end
