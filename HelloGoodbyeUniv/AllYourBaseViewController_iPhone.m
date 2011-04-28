//
//  HelloGoodbyeViewController_iPhone.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseViewController_iPhone.h"


@implementation AllYourBaseViewController_iPhone

- (id)initWithModel:(AllYourBaseModel *)theModel base:(int)someBase
{
    BOOL alternateDecimal = NO;
    if (someBase == 0) {
        someBase = 10;
        alternateDecimal = YES;
    } else
    if ((someBase < 2) || (someBase > 100)) {
        NSLog(@"only bases from 2 to 100 are supported");
        return nil; // early return because it's useless to invoke [self init]
    }
    
    NSString *nibForBase = nil;
    if (alternateDecimal) {
        nibForBase = @"AllYourBaseViewController_iPhoneAlternate10";
        
    } else
    {
        NSString *nibPrefix = @"AllYourBaseViewController_iPhone";
        nibForBase = [NSString stringWithFormat:@"%@%02d", nibPrefix, someBase];
    }
    
    self = [super initWithNibName:nibForBase bundle:nil model:theModel];
    if (self) {
        self.base = someBase;
        if (alternateDecimal) {
            self.title = @"Base 10*";           
        } else
        {
            self.title = [NSString stringWithFormat:@"Base %d", someBase];
        }
    }
    return self;
}

@end
