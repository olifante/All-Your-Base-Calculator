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

    NSMutableArray *vcs = [[[NSMutableArray alloc] init] autorelease];
    
    NSMutableArray *bases = [NSMutableArray arrayWithObjects:
                             [NSNumber numberWithInt:10],
                             [NSNumber numberWithInt:0],
                             [NSNumber numberWithInt:12],
                             [NSNumber numberWithInt:16],
                             nil];
    for (int i = 2; i < 17; i++) {
        NSNumber *num = [NSNumber numberWithInt:i];
        if (![bases containsObject:num]) {
            [bases addObject:num];
        }
    }

    for (NSNumber *item in bases) {
        int i = [item intValue];
        UIViewController *vc = [[[AllYourBaseViewController_iPhone alloc] 
                                 initWithModel:theModel
                                 base:i
                                 ] autorelease];    
        [vcs addObject:vc];
        
    }

    UITabBarController *tbc = [[[UITabBarController alloc] init] autorelease];
    tbc.delegate = theModel;
    tbc.viewControllers = vcs;
//    tbc.moreNavigationController.navigationBarHidden = YES;
    tbc.moreNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
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
