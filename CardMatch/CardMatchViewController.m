//
//  CardMatchViewController.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 11/21/13.
//  Copyright (c) 2013 Vivek Sivakumar. All rights reserved.
//

#import "CardMatchViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface CardMatchViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (nonatomic) Deck *deck;

@end

@implementation CardMatchViewController

- (Deck *)deck {
    if (!_deck) _deck = [self createDeck];
    return _deck;
}

- (Deck *)createDeck{
    return [[PlayingCardDeck alloc] init];
}

- (void) setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void) endGame {
    self.flipsLabel.text = @"Game Over!";
}

- (IBAction)touchCardButton:(UIButton *)sender {
    if ([sender.currentTitle length]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"card-back"]
                          forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
    } else {
        if ([self.deck cardsLeft]){
            Card *drawnCard = [self.deck drawRandomCard];
            [sender setBackgroundImage:[UIImage imageNamed:@"card-front"]
                              forState:UIControlStateNormal];
            [sender setTitle:drawnCard.contents forState:UIControlStateNormal];
            self.flipCount++;
        }
        else {
            [self endGame];
        }
    }
}


@end
