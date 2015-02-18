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
#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

- (void)drawRect:(CGRect)rect {
    [self drawCard];
    [self drawCardImage];
}

//Override as needed
- (void)drawCard {
    UIBezierPath* roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    [[UIColor blackColor] setStroke];
    [roundedRect fill];
    [roundedRect stroke];
}

//ABSTRACT
- (void)drawCardImage {
    return;
}

@end
