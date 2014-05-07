//
//  CardMatchingGame.h
//  CardMatch
//
//  Created by Vivek Sivakumar on 12/6/13.
//  Copyright (c) 2013 Vivek Sivakumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)count
                           ofType:(NSUInteger)gameType
                        usingDeck:(Deck *)deck;

- (Card *)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (NSUInteger)chosenCards;

- (BOOL)gameOver;

@property (nonatomic, strong) NSMutableArray *matches; // of Card
@property (nonatomic, readonly) NSUInteger gameType;
@property (nonatomic, readonly) NSInteger score;

@end
