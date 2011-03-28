//
//  HelloGoodbyeViewController_iPhone.h
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelloGoodbyeViewController.h"
#import "HelloGoodbyeViewController_iPhoneL.h"

@interface HelloGoodbyeViewController_iPhone : HelloGoodbyeViewController {
    
}

- (void)orientationChanged:(NSNotification *)notification;

@end
