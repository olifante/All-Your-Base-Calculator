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

    UIViewController *vc10 = [[[AllYourBaseViewController_iPhone alloc] 
                              initWithModel:theModel
                              base:10
                             ] autorelease];
    UIViewController *vc16 = [[[AllYourBaseViewController_iPhone alloc] 
                              initWithModel:theModel
                              base:16
                              ] autorelease];
    UIViewController *vc8 = [[[AllYourBaseViewController_iPhone alloc] 
                              initWithModel:theModel
                              base:8
                              ] autorelease];
    UIViewController *vc4 = [[[AllYourBaseViewController_iPhone alloc] 
                              initWithModel:theModel
                              base:4
                              ] autorelease];
//    UIViewController *vc10a = [[[AllYourBaseViewController_iPhone alloc] 
//                              initWithNibName:@"AllYourBaseViewController_iPhone10a" bundle:nil model:theModel
//                              base:10
//                              ] autorelease];
//    UIViewController *vc10s = [[[AllYourBaseViewController_iPhone alloc] 
//                                initWithNibName:@"AllYourBaseViewController_iPhone10s" bundle:nil model:theModel
//                                base:10
//                                ] autorelease];
//    UIViewController *vc10sa = [[[AllYourBaseViewController_iPhone alloc] 
//                                initWithNibName:@"AllYourBaseViewController_iPhone10sa" bundle:nil model:theModel
//                                base:10
//                                ] autorelease];    

    UITabBarController *tbc = [[[UITabBarController alloc] init] autorelease];
    tbc.delegate = theModel;
    tbc.viewControllers = [NSArray arrayWithObjects: 
                           vc10, 
                           vc16,
                           vc8,
                           vc4,
                           nil];
    self.tabBarViewController = tbc;
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
