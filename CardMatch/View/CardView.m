//
//  CardView.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 2/12/15.
//  Copyright (c) 2015 Vivek Sivakumar. All rights reserved.
//

#import "CardView.h"

@implementation CardView

#pragma mark initialization
//ABSTRACT
- (void)setup {
    return;
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark drawing
//ABSTRACT
- (void)drawRect:(CGRect)rect
{
    return;
}

@end
