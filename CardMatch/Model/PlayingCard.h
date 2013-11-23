//
//  PlayingCard.h
//  CardMatch
//
//  Created by Vivek Sivakumar on 11/22/13.
//  Copyright (c) 2013 Vivek Sivakumar. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString* suit;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
