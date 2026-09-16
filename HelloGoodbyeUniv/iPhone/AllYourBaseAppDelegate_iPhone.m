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
    AllYourBaseModel *theModel = [[AllYourBaseModel alloc] init];

    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    
    NSMutableArray *bases = [@[
                             @(10),
                             @(6),
                             @(7),
                             @(12),
                             nil];
    for (int i = 2; i < 17; i++) {
        NSNumber *num = @(i);
        if (![bases containsObject:num]) {
            [bases addObject:num];
        }
    }

    for (NSNumber *item in bases) {
        int i = [item intValue];
        UIViewController *vc = [[AllYourBaseViewController_iPhone alloc] 
                                 initWithModel:theModel
                                 base:i
                                 ];    
        [vcs addObject:vc];
        
    }

    UIViewController *vcAlternate10 = [[AllYourBaseViewController_iPhone alloc] 
                                        initWithModel:theModel
                                        base:0
                                        ];
    [vcs addObject:vcAlternate10];
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    tbc.delegate = theModel;
    tbc.viewControllers = vcs;
//    tbc.selectedIndex = 2;
//    tbc.moreNavigationController.navigationBarHidden = YES;
    tbc.moreNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.tabBarViewController = tbc;
    self.window.rootViewController = self.tabBarViewController;
    [self.window addSubview:self.tabBarViewController.view];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
