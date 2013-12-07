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
#import "CardMatchingGame.h"

@interface CardMatchViewController ()
@property (nonatomic) Deck *deck;
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *score;
@end

@implementation CardMatchViewController

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (Deck *)deck {
    if (!_deck) _deck = [self createDeck];
    return _deck;
}

- (Deck *)createDeck{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int index = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:index];
    [self updateUI:[self.game gameOver]];
}

- (void)updateUI:(BOOL)endGame {
    for (UIButton* cardButton in self.cardButtons){
        int index = [self.cardButtons indexOfObject:cardButton];
        Card* card = [self.game cardAtIndex:index];
        if (endGame){
            [cardButton setTitle:card.contents forState:UIControlStateNormal];
            [cardButton setBackgroundImage:[UIImage imageNamed:@"card-front"] forState:UIControlStateNormal];
            cardButton.enabled = !card.isMatched;
            self.score.text = [NSString stringWithFormat:@"Game Over! Score: %d", self.game.score];
        }
        else {
            [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
            [cardButton setBackgroundImage:[self imageForCard:card] forState:UIControlStateNormal];
            cardButton.enabled = !card.isMatched;
            self.score.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
        }
    }
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)imageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"card-front" : @"card-back"];
}


@end
