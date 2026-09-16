//
//  HelloGoodbyeUnivAppDelegate.h
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllYourBaseAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarViewController;

@end
