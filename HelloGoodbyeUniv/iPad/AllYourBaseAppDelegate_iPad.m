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
    
    NSMutableArray *vcs = [[[NSMutableArray alloc] init] autorelease];

    for (int i = 2; i < 37; i++) {
        UIViewController *vc = [[[AllYourBaseViewController_iPad alloc] 
                                 initWithModel:theModel
                                 base:i
                                 ] autorelease];
        [vcs addObject:vc];

        if (i == 10) {
            UIViewController *vc10alternate = [[[AllYourBaseViewController_iPad alloc] 
                                                initWithNibName:@"AllYourBaseViewController_iPadAlternate10"
                                                bundle:nil
                                                model:theModel
                                                ] autorelease];
            vc10alternate.title = @"Base 10*";
            [vcs addObject:vc10alternate];            
        }    
    }
    
    UITabBarController *tbc = [[[UITabBarController alloc] init] autorelease];
    tbc.delegate = theModel;
    tbc.viewControllers = vcs;
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
