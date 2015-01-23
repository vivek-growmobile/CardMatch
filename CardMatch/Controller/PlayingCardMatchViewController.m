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

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

@end
