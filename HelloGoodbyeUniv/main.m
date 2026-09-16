    //
//  main.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllYourBaseAppDelegate_iPhone.h"
#import "AllYourBaseAppDelegate_iPad.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        NSString *delegateClassName = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
            NSStringFromClass([AllYourBaseAppDelegate_iPad class]) :
            NSStringFromClass([AllYourBaseAppDelegate_iPhone class]);
        return UIApplicationMain(argc, argv, nil, delegateClassName);
    }
}
