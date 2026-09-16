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
    NSLog(@"DIAG scene:willConnectToSession: called, scene=%@ appDelegate=%@ window=%@", scene, appDelegate, appDelegate.window);
    appDelegate.window.windowScene = windowScene;
    [appDelegate.window makeKeyAndVisible];
    NSLog(@"DIAG after attach: window.windowScene=%@ window.rootViewController=%@ window.isKeyWindow=%d window.hidden=%d", appDelegate.window.windowScene, appDelegate.window.rootViewController, appDelegate.window.isKeyWindow, appDelegate.window.hidden);
}

@end
