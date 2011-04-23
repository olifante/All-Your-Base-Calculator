//
//  HelloGoodbyeUnivAppDelegate_iPad.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseAppDelegate_iPad.h"
#import "AllYourBaseViewController_iPad.h"

@implementation AllYourBaseAppDelegate_iPad

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    AllYourBaseModel *theModel = [[[AllYourBaseModel alloc] init] autorelease];
    
    UIViewController *vc10 = [[[AllYourBaseViewController_iPad alloc] 
                              initWithModel:theModel
                              base:10
                              ] autorelease];
    UIViewController *vc8 = [[[AllYourBaseViewController_iPad alloc] 
                              initWithModel:theModel
                              base:8
                              ] autorelease];
    UIViewController *vc4 = [[[AllYourBaseViewController_iPad alloc] 
                              initWithModel:theModel
                              base:4
                              ] autorelease];
    
    UITabBarController *tbc = [[[UITabBarController alloc] init] autorelease];
    tbc.delegate = theModel;
    tbc.viewControllers = [NSArray arrayWithObjects: 
                           vc10, 
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
