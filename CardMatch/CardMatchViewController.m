//
//  CardMatchViewController.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 11/21/13.
//  Copyright (c) 2013 Vivek Sivakumar. All rights reserved.
//

#import "CardMatchViewController.h"
//#import "PlayingCardDeck.h"
#import "Card.h"
#import "CardMatchingGame.h"

@interface CardMatchViewController ()
@property (nonatomic) Deck *deck;
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameType;
@end

@implementation CardMatchViewController

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                             ofType:[self getGameType]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (void)newGame {
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                     ofType:[self getGameType]
                                                  usingDeck:[self createDeck]];
}

- (Deck *)deck {
    if (!_deck) _deck = [self createDeck];
    return _deck;
}

//ABSTRACT
- (Deck *)createDeck{
    return nil;
    //return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)getGameType {
    NSString *title = [self.gameType titleForSegmentAtIndex:self.gameType.selectedSegmentIndex];
    NSUInteger selected = [title integerValue];
    NSLog(@"Getting the game type %lu", selected);
    return selected;
    
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int index = (int)[self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:index];
    [self updateUI:[self.game gameOver]];
}

- (IBAction)dealButton:(UIButton *)sender {
    [self newGame];
    [self updateUI:[self.game gameOver]];
}
- (IBAction)endGameButton:(id)sender {
    [self updateUI:YES];
}

- (void)updateUI:(BOOL)endGame {
    for (UIButton* cardButton in self.cardButtons){
        int index = (int)[self.cardButtons indexOfObject:cardButton];
        Card* card = [self.game cardAtIndex:index];
        if (endGame){
            [cardButton setTitle:card.contents forState:UIControlStateNormal];
            [cardButton setBackgroundImage:[UIImage imageNamed:@"card-front"] forState:UIControlStateNormal];
            cardButton.enabled = !card.isMatched;
            self.score.text = [NSString stringWithFormat:@"Game Over! Score: %ld", self.game.score];
            [self.gameType setEnabled:YES];
        }
        else {
            [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
            [cardButton setBackgroundImage:[self imageForCard:card] forState:UIControlStateNormal];
            cardButton.enabled = !card.isMatched;
            self.score.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
        }
    }
    if (endGame){
        return;
    }
    else {
//        NSString* matchText = @"Just Matched:";
//        for (Card* card in self.game.matches){
//            matchText = [matchText stringByAppendingString:[NSString stringWithFormat:@" %@", card.contents]];
//            NSLog(@"%@", matchText);
//        }
//        self.justMatched.text = matchText;
        
        if ([self.game chosenCards] == 0){
            [self.gameType setEnabled:YES];
        }
        else {
            [self.gameType setEnabled:NO];
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
