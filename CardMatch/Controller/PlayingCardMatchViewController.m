//
//  PlayingCardMatchViewController.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 5/6/14.
//  Copyright (c) 2014 Vivek Sivakumar. All rights reserved.
//

#import "PlayingCardMatchViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"

@interface PlayingCardMatchViewController ()

@end

@implementation PlayingCardMatchViewController

#pragma mark abstract implementations
//Override
- (CardView *) createCardViewInFrame:(CGRect)frame{
    return [[PlayingCardView alloc] initWithFrame:frame];
}

//Override
- (NSUInteger)getGameType {
    NSUInteger gameType = 2;
    return gameType;
}

//Override
- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

//Override
- (void)drawCard:(Card *)card
      onCardView:(CardView *)cardView {
    if ([card isKindOfClass:[PlayingCard class]]){
        PlayingCard* playingCard = (PlayingCard *)card;
        if ([cardView isKindOfClass:[PlayingCardView class]]){
            PlayingCardView* playingCardView = (PlayingCardView *)cardView;
            playingCardView.suit = playingCard.suit;
            playingCardView.rank = playingCard.rank;
            playingCardView.faceUp = playingCard.chosen;
        }
    }
}

#pragma mark deprecate?
//Override
- (NSAttributedString *)illustrateCard:(Card *)card {
    return [[NSAttributedString alloc] initWithString:card.contents];
}

//Override
- (NSAttributedString *)titleForCard:(Card *)card {
    return card.isChosen ? [self illustrateCard:card] : [[NSAttributedString alloc] initWithString:@""];
}

//Override
- (UIImage *)imageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"card-front" : @"card-back"];
}

@end
