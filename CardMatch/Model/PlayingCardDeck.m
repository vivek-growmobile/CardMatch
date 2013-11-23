//
//  PlayingCardDeck.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 11/23/13.
//  Copyright (c) 2013 Vivek Sivakumar. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (instancetype) init {
    self = [super init];
    if (self){
        for (NSString* suit in [PlayingCard validSuits]){
            for (int rank = 1; rank <= [PlayingCard maxRank]; rank++){
                PlayingCard *newCard = [[PlayingCard alloc] init];
                newCard.suit = suit;
                newCard.rank = rank;
                [self addCard:newCard];
            }
        }
    }
    
    return self;
}

@end
