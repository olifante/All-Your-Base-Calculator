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
    UITabBarController *tbc = [[[UITabBarController alloc] init] autorelease];
    UIViewController *vc1 = [[[AllYourBaseViewController_iPhone alloc] 
                             initWithNibName:nil 
                             bundle:nil 
                             model:theModel
                             ] autorelease];
    vc1.title = @"Decimal";
    UIViewController *vc2 = [[[AllYourBaseViewController_iPhone alloc] 
                             initWithNibName:@"AllYourBaseViewController_iPhone10a" 
                             bundle:nil 
                             model:theModel
                             ] autorelease];
    vc2.title = @"Standard Decimal";
    UIViewController *vc3 = [[[AllYourBaseViewController_iPhone alloc] 
                              initWithNibName:@"AllYourBaseViewController_iPhone08" 
                              bundle:nil 
                              model:theModel
                              ] autorelease];
    vc3.title = @"Octal";
    tbc.viewControllers = [NSArray arrayWithObjects: 
                           vc1, 
                           vc2,
                           vc3,
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
