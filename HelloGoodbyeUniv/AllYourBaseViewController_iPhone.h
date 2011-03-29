//
//  HelloGoodbyeViewController_iPhone.h
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllYourBaseViewController.h"
#import "AllYourBaseViewController_iPhoneL.h"

@interface AllYourBaseViewController_iPhone : AllYourBaseViewController {
    
}

- (void)orientationChanged:(NSNotification *)notification;

@end
