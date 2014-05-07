//
//  CardMatchingGame.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 12/6/13.
//  Copyright (c) 2013 Vivek Sivakumar. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger turnScore;
@property (nonatomic, readwrite) NSUInteger gameType;

@property (nonatomic, strong) NSMutableArray *cards; // of Card
//@property (nonatomic, strong) NSMutableArray *matches; // of Card

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
        NSLog(@"Game Type %lu", self.gameType);
    }
    return self;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2

- (Card *)chooseCardAtIndex:(NSUInteger)index {
    Card* card = nil;
    if (index < self.cards.count){
        card = self.cards[index];
        // if this card is already chosen
        if (card.isChosen){
            card.chosen = NO;
            
            [self.matches removeObjectIdenticalTo:card];
            self.turnScore = 0;
            
            NSLog(@"Unchoosing Chosen Card, Flipping: %@", card.contents);
            NSLog(@"Matches: %lu", self.matches.count);
        }
        //if the card hasnt been chosen
        else {
            card.chosen = YES;
            
            //if there are already matches in the queue
            if (self.matches.count > 0){
                int matchScore = [card match:self.matches];
                NSLog(@"Match Score: %d", matchScore);
                //if there is a match
                if (matchScore > 0 || self.turnScore > 0){
                    [self.matches addObject:card];
                    self.turnScore += matchScore;
                    
                    if (self.matches.count == self.gameType){
                        while (self.matches.count > 0) {
                            Card* match = self.matches[0];
                            match.matched = YES;
                            [self.matches removeObjectAtIndex:0];
                        }
                        self.score += (self.turnScore * MATCH_BONUS);
                        self.turnScore = 0;
                        NSLog(@"Complete Match, Adding: %@ To Matches", card.contents);
                        NSLog(@"Matches: %lu (Should be empty)", self.matches.count);
                    }
                    else if (matchScore > 0 && self.matches.count < self.gameType){
                        NSLog(@"Incomplete Match, Adding: %@ To Matches", card.contents);
                        NSLog(@"Matches: %lu", self.matches.count);
                    }
                }
                //if there is no match
                else {
                    self.score -= MISMATCH_PENALTY;
                    Card* prevChosen = [self.matches objectAtIndex:0];
                    prevChosen.chosen = NO;
                    [self.matches replaceObjectAtIndex:0 withObject:card];
                }
            }
            //no matches in the queue
            else {
                [self.matches addObject:card];
                NSLog(@"Matches Empty, Adding: %@", card.contents);
            }
        }
    }
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

- (BOOL)gameOver {
    NSMutableArray* cardsRemaining = [[NSMutableArray alloc] init];
    for (Card* card in self.cards){
        if (!card.matched) [cardsRemaining addObject:card];
    }
    //NSLog(@"Cards Remaining: %d", cardsRemaining.count);
//    if (cardsRemaining.count == 2){
//        for (Card* card in cardsRemaining){
//            NSLog(@"%@", card.contents);
//        }
//    }
    for (Card* card in cardsRemaining){
        int match = [card match:cardsRemaining];
        //NSLog(@"%d", match);
        if (match > [card match:@[card]]) return NO;
    }
    return YES;
}


@end
