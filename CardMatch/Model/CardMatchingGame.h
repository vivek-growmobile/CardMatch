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
//The number of cards in play that have been chosen
// WAS FOR GAME TYPE CONTROL BUTTON
//- (NSUInteger)chosenCards;

//An array holding cards that have been flipped on this turn
@property (nonatomic, strong, readonly) NSMutableArray *matches; // of Card
//The number of cards that can be matched together in a turn
@property (nonatomic, readonly) NSUInteger gameType;
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) BOOL gameOver;

- (void)endGame;

@end
