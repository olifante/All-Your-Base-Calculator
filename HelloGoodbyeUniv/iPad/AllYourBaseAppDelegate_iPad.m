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
    AllYourBaseModel *theModel = [[AllYourBaseModel alloc] init];
    
    NSMutableArray *vcs = [[NSMutableArray alloc] init];

    NSMutableArray *bases = [@[
                             @(10),
                             @(6),
                             @(7),
                             @(9),
                             @(16),
                             @(25),
                             @(36),
                             ] mutableCopy];
    for (int i = 2; i < 37; i++) {
        NSNumber *num = @(i);
        if (![bases containsObject:num]) {
            [bases addObject:num];
        }
    }

    for (NSNumber *item in bases) {
        int i = [item intValue];
        UIViewController *vc = [[AllYourBaseViewController_iPad alloc] 
                                 initWithModel:theModel
                                 base:i
                                 ];
        [vcs addObject:vc];
    }

    UIViewController *vcAlternate10 = [[AllYourBaseViewController_iPad alloc] 
                                        initWithModel:theModel
                                        base:0
                                        ];
    [vcs addObject:vcAlternate10];
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    tbc.delegate = theModel;
    tbc.viewControllers = vcs;
//    tbc.selectedIndex = 3;
//    tbc.moreNavigationController.navigationBarHidden = YES;
    tbc.moreNavigationController.navigationBar.barStyle = UIBarStyleBlack;
    tbc.moreNavigationController.navigationBar.translucent = YES;
    self.tabBarViewController = tbc;
    if (!self.window) {
        self.window = [[UIWindow alloc] init];
    }
    self.window.rootViewController = self.tabBarViewController;
    [self.window addSubview:self.tabBarViewController.view];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
