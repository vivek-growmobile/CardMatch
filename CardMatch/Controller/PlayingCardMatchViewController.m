//
//  PlayingCardMatchViewController.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 5/6/14.
//  Copyright (c) 2014 Vivek Sivakumar. All rights reserved.
//

#import "PlayingCardMatchViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardMatchViewController ()

@end

@implementation PlayingCardMatchViewController

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
