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
    
    NSArray *bases = [NSArray arrayWithObjects:
                      [NSNumber numberWithInt:2],
                      [NSNumber numberWithInt:8],
                      [NSNumber numberWithInt:10],
                      [NSNumber numberWithInt:12],
                      nil];
    for (NSNumber *item in bases) {
        int i = [item intValue];
        UIViewController *vc = [[[AllYourBaseViewController_iPhone alloc] 
                                 initWithModel:theModel
                                 base:i
                                 ] autorelease];    
        [vcs addObject:vc];
        
        if (i == 10) {
            UIViewController *vc10alternate = [[[AllYourBaseViewController_iPhone alloc] 
                                                initWithNibName:@"AllYourBaseViewController_iPhoneAlternate10"
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
