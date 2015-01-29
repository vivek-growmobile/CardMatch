//
//  CardMatchingGame.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 12/6/13.
//  Copyright (c) 2013 Vivek Sivakumar. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, strong, readwrite) NSMutableArray* matches;
@property (nonatomic, readwrite) NSUInteger gameType;
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite, getter = isGameOver) BOOL gameOver;

@property (nonatomic, strong) NSMutableArray *cards; // of Card


@end

@implementation CardMatchingGame

- (instancetype)initWithCardCount:(NSUInteger)count
                           ofType:(NSUInteger)gameType
                        usingDeck:(Deck *)deck {
    self = [super init];
    
    if (self){
        if (count > deck.cardsLeft) self = nil;
        else {
            self.gameType = gameType;
            self.matches = [[NSMutableArray alloc] init];
            self.cards = [[NSMutableArray alloc] init];
            for (int i = 0; i < count; i++){
                Card* newCard = [deck drawRandomCard];
                [self.cards addObject:newCard];
            }
        }
        self.gameOver = NO;
        NSLog(@"Game Type %d", (int)self.gameType);
    }
    return self;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2

- (Card *)chooseCardAtIndex:(NSUInteger)index {
    Card* card = nil;
    if (index < self.cards.count){
        card = self.cards[index];
        // If this card is already chosen
        if (card.isChosen){
            card.chosen = NO;
            [self.matches removeObjectIdenticalTo:card];
            
            NSLog(@"Unchoosing %@", card.contents);
            NSLog(@"Num of Matches: %d", (int)self.matches.count);
        }
        //if the card hasnt been chosen
        else {
            card.chosen = YES;
            [self.matches addObject:card];
             NSLog(@"Chose %@", card.contents);
            // If we've reached the max number of choosable cards for this game type
            if (self.matches.count == self.gameType){

                int matchScore = [card match:self.matches];
                NSLog(@"Match Score: %d", matchScore);
                
                //If it was a good match add up the score and remove all the involved cards
                if (matchScore > 0) {
                    while (self.matches.count > 0) {
                        Card* match = self.matches[0];
                        match.matched = YES;
                        [self.matches removeObjectAtIndex:0];
                    }
                    NSLog(@"Num of Matches: %d (should be zero)", (int)self.matches.count);
                    self.score += (matchScore * MATCH_BONUS);
                }
                
                //If it was a bad match unchoose the earliest chosen match
                else {
// If you dont get a match: flip over all cards but the most recently chosen OR
// flip over just the earliest chosen one?
                    //while (self.matches.count > 1) {
                    Card* match = self.matches[0];
                    match.matched = NO;
                    match.chosen = NO;
                    [self.matches removeObjectAtIndex:0];
                    //}
                    //NSLog(@"Num of Matches: %d", (int)self.matches.count);
                    self.score -= MISMATCH_PENALTY;
                }
                //NSLog(@"Game Score: %d", self.score);
            }
        }
    }
    if([self checkIfGameIsOver]) [self endGame];
    return card;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    if (index < self.cards.count) return self.cards[index];
    else return nil;
}

- (NSUInteger)chosenCards {
    NSUInteger numChosen = 0;
    for (Card* card in self.cards){
        if (card.chosen) {
            numChosen += 1;
        }
    }
    return numChosen;
}

//- (BOOL)isGameOver{
//    //If game hasn't been ended by user, check if game has naturally ended
////    if (!_gameOver){
////        _gameOver = [self checkIfGameIsOver];
////    }
//    return _gameOver;
//}

- (BOOL)checkIfGameIsOver {
    //Get all unmatched cards
    NSMutableArray* cardsRemaining = [[NSMutableArray alloc] init];
    for (Card* card in self.cards){
        if (!card.matched) [cardsRemaining addObject:card];
    }
    
    if (cardsRemaining.count == 0) return YES;
    else {
        //See if there are any potential matches left
        Card* card = [self.cards objectAtIndex:0];
        
        int remainingScore = [card match:cardsRemaining];
        if (remainingScore > 0){
            NSLog(@"%d Points Still on the Board!", remainingScore);
            return NO;
        }
        else {
            return YES;
        }
    }

}

- (void)endGame {
    self.gameOver = YES;
    for (Card* card in self.cards){
        card.chosen = YES;
    }
}


@end
