//
//  AllYourBaseSceneDelegate.m
//  HelloGoodbyeUniv
//

#import "AllYourBaseSceneDelegate.h"
#import "AllYourBaseAppDelegate.h"

@implementation AllYourBaseSceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions
{
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    AllYourBaseAppDelegate *appDelegate = (AllYourBaseAppDelegate *)UIApplication.sharedApplication.delegate;
    appDelegate.window.windowScene = windowScene;
    [appDelegate.window makeKeyAndVisible];
}

@end
