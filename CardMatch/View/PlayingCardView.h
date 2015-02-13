//
//  PlayingCardView.h
//  CardMatch
//
//  Created by Vivek Sivakumar on 2/6/15.
//  Copyright (c) 2015 Vivek Sivakumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface PlayingCardView : CardView

#pragma mark public properties
@property (nonatomic, strong) NSString* suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic) BOOL faceUp;

@end
