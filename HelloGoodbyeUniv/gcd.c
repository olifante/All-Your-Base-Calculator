//
//  gcd.c
//  AllYourBase
//
//  Created by Tiago Henriques on 4/19/11.
//  Copyright 2011 notknot. All rights reserved.
//

#include "gcd.h"

/* gcd: compute greatest common divisor between p and q */
int gcd(int p, int q) {
    int	r;
    if ((r = p%q) == 0) {
        return q;        
    }
    else {
        return gcd(q, r);        
    }
}