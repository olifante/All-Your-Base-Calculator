//
//  MyNSString.m
//  HelloGoodbyeUniv
//
//  Created by Tiago Henriques on 3/27/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "NKString.h"


@implementation NSString (NKString)

- (BOOL)isEmptyNK
{
    return [self isEqualToString:@""];
}

- (BOOL)isNotEmptyNK
{
    return ![self isEqualToString:@""];
}

@end
