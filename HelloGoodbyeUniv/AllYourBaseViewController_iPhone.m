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
    if (!someBase || (someBase < 2) || (someBase > 100)) {
        NSLog(@"only bases from 2 to 100 are supported");
        return nil; // early return because it's useless to invoke [self init]
    }
    
    NSString *nibPrefix = @"AllYourBaseViewController_iPhone";
    NSString *nibForBase = [NSString stringWithFormat:@"%@%02d", nibPrefix, someBase];
    
    self = [super initWithNibName:nibForBase bundle:nil model:theModel];
    if (self) {
        self.base = someBase;
        self.title = [NSString stringWithFormat:@"Base %d", someBase];
    }
    return self;
}

@end
