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
@property (weak, nonatomic) IBOutlet UILabel *matchedTicker;
@property (strong, nonatomic) NSString* matchedTickerText;
@end

@implementation CardMatchViewController

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                             ofType:[self getGameType]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (void)newGame {
    //Dont have to release.. if you set strong pointer to something else in heap it lowers its Ref count.
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

//ABSTRACT
- (NSUInteger)getGameType {
    return 0;
//    NSString *title = [self.gameType   titleForSegmentAtIndex:self.gameType.selectedSegmentIndex];
//    NSUInteger selected = [title integerValue];
//    NSLog(@"Getting the game type %lu", selected);
//    return selected;
    
}

- (IBAction)touchCardButton:(UIButton *)sender {
    //Collect data before drawing card
    NSInteger oldScore = self.game.score;
    NSMutableArray *turnMatches = [[NSMutableArray alloc] initWithArray:self.game.matches];
    //DrawCard
    int index = (int)[self.cardButtons indexOfObject:sender];
    Card* drawnCard = [self.game chooseCardAtIndex:index];
    //Update UI for drawn card
    NSInteger newScore = self.game.score;
    NSInteger turnScore = newScore - oldScore;
    
    [turnMatches addObject:drawnCard];
    [self updateUiWithTurnMatches:turnMatches
                     AndTurnScore:turnScore];
}

- (IBAction)dealButton:(UIButton *)sender {
    [self newGame];
    [self updateUi];
}
- (IBAction)endGameButton:(id)sender {
    [self.game endGame];
    [self updateUi];
}

- (NSString *)generateMatchedTickerTextWithMatches:(NSArray *)turnMatches
                                          AndScore:(NSInteger)turnScore {
    NSString* matchText = @"Matched : ";
    for (Card* card in turnMatches){
        matchText = [matchText stringByAppendingString:[NSString stringWithFormat:@"%@ ", card.contents]];
    }
    matchText = [matchText stringByAppendingString:[NSString stringWithFormat:@"for %ld points", turnScore]];
    return matchText;
}

- (void)updateUiWithTurnMatches:(NSArray *)turnMatches
                   AndTurnScore:(NSInteger)turnScore {
    
    [self updateUi];
    self.matchedTicker.text = [self generateMatchedTickerTextWithMatches:turnMatches
                                                                AndScore:turnScore];
    
}

- (void)updateUi{
    BOOL gameOver = self.game.gameOver;
    for (UIButton* cardButton in self.cardButtons){
        int index = (int)[self.cardButtons indexOfObject:cardButton];
        Card* card = [self.game cardAtIndex:index];
        if (gameOver){
            [cardButton setTitle:card.contents forState:UIControlStateNormal];
            [cardButton setBackgroundImage:[UIImage imageNamed:@"card-front"] forState:UIControlStateNormal];
            cardButton.enabled = !card.isMatched;
            self.score.text = [NSString stringWithFormat:@"Game Over! Score: %ld", self.game.score];
            //[self.gameType setEnabled:YES];
        }
        else {
            [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
            [cardButton setBackgroundImage:[self imageForCard:card] forState:UIControlStateNormal];
            cardButton.enabled = !card.isMatched;
            self.score.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
            self.matchedTicker.text = @"Matched: ";
        }
        
    }
    
// WAS FOR GAME TYPE CONTROL BUTTON
//    if (endGame){
//        return;
//    }
//    else {
//        NSString* matchText = @"Just Matched:";
//        for (Card* card in self.game.matches){
//            matchText = [matchText stringByAppendingString:[NSString stringWithFormat:@" %@", card.contents]];
//            NSLog(@"%@", matchText);
//        }
//        self.justMatched.text = matchText;
//        
//        if ([self.game chosenCards] == 0){
//            [self.gameType setEnabled:YES];
//        }
//        else {
//            [self.gameType setEnabled:NO];
//        }
//    }
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)imageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"card-front" : @"card-back"];
}


@end
