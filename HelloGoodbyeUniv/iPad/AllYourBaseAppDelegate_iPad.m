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
    UITabBarController *tbc = [[[UITabBarController alloc] init] autorelease];
    UIViewController *vc1 = [[[AllYourBaseViewController_iPad alloc] 
                              initWithNibName:nil 
                              bundle:nil 
                              model:theModel
                              ] autorelease];
    vc1.title = @"Decimal";
    UIViewController *vc2 = [[[AllYourBaseViewController_iPad alloc] 
                              initWithNibName:@"AllYourBaseViewController_iPad2" 
                              bundle:nil 
                              model:theModel
                              ] autorelease];
    vc2.title = @"Standard Decimal";
    tbc.viewControllers = [NSArray arrayWithObjects: 
                           vc1, 
                           vc2,
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
