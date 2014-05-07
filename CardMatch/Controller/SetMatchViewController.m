//
//  SetMatchViewController.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 5/6/14.
//  Copyright (c) 2014 Vivek Sivakumar. All rights reserved.
//

#import "SetMatchViewController.h"
#import "SetCardDeck.h"

@interface SetMatchViewController ()

@end

@implementation SetMatchViewController

//Override
- (NSUInteger)getGameType {
    NSUInteger gameType = 3;
    return gameType;
}

- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

@end
