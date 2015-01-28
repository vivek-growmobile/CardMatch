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
- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

//Override
- (UIImage *)imageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"card-front" : @"card-back"];
}

@end
