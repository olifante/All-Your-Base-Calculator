//
//  HelloGoodbyeViewController_iPad.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseViewController_iPad.h"


@implementation AllYourBaseViewController_iPad

- (id)initWithModel:(AllYourBaseModel *)theModel base:(int)someBase
{
    if (!someBase || (someBase < 2) || (someBase > 100)) {
        NSLog(@"only bases from 2 to 100 are supported");
        return nil; // early return because it's useless to invoke [self init]
    }
    
    NSString *nibPrefix = @"AllYourBaseViewController_iPad";
    NSString *nibForBase = [NSString stringWithFormat:@"%@%02d", nibPrefix, someBase];
    
    self = [super initWithNibName:nibForBase bundle:nil model:theModel];
    if (self) {
        self.base = someBase;
        self.title = [NSString stringWithFormat:@"Base %d", someBase];
    }
    return self;
}

@end
