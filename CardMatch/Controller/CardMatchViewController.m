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
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (strong, nonatomic) NSString *matchedTickerText;
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

- (IBAction)dealButton:(UIButton *)sender {
    [self newGame];
    [self updateUi];
}

- (IBAction)endGameButton:(id)sender {
    [self.game endGame];
    [self updateUi];
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
    [self setMatchedTickerTextWithMatches:turnMatches
                                      AndScore:turnScore];
    [self updateUi];
}


- (void)setMatchedTickerTextWithMatches:(NSArray *)turnMatches
                               AndScore:(NSInteger)turnScore {
    NSString* matchTickerText = @"";
    if (turnMatches.count == self.game.gameType){
        for (Card* card in turnMatches){
            matchTickerText = [matchTickerText stringByAppendingString:[NSString stringWithFormat:@"%@ ", card.contents]];
        }
        matchTickerText = [matchTickerText stringByAppendingString:
                           [NSString stringWithFormat:@"%@ %d points", (turnScore > 0 ? @"Match! " : @"Don't Match!"), (int)turnScore]];
    }
    self.matchedTicker.text = matchTickerText;
}

- (void)updateUi{
    BOOL gameOver = self.game.gameOver;
    //Update each card
    for (UIButton* cardButton in self.cardButtons){
        int index = (int)[self.cardButtons indexOfObject:cardButton];
        Card* card = [self.game cardAtIndex:index];
        [cardButton setTitle:(gameOver ? card.contents : [self titleForCard:card])
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:(gameOver ? [UIImage imageNamed:@"card-front"] : [self imageForCard:card])
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    //General Updates
    if (gameOver){
        self.score.text = [NSString stringWithFormat:@"Game Over! Score: %d", (int)self.game.score];
        self.matchedTicker.text = @"";
        self.dealButton.enabled = YES;
        //[self.gameType setEnabled:YES];
    }
    else {
        self.score.text = [NSString stringWithFormat:@"Score: %d", (int)self.game.score];
        self.dealButton.enabled = NO;
        //[self.gameType setEnabled:YES];
    }
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)imageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"card-front" : @"card-back"];
}


@end
