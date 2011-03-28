//
//  HelloGoodbyeUnivAppDelegate_iPhone.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "HelloGoodbyeUnivAppDelegate_iPhone.h"
#import "HelloGoodbyeViewController_iPhone.h"

@implementation HelloGoodbyeUnivAppDelegate_iPhone

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.viewController = [[HelloGoodbyeViewController_iPhone alloc] init];
    self.window.rootViewController = self.viewController;
    [self.window addSubview:self.viewController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
	[super dealloc];
}

@end
