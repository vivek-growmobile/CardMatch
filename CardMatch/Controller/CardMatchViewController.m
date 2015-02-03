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
#import "MatchHistoryViewController.h"

@interface CardMatchViewController ()
@property (nonatomic) Deck *deck;
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *score;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *gameType;
@property (weak, nonatomic) IBOutlet UILabel *matchedTicker;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (strong, nonatomic) NSMutableAttributedString *lastMatchedText;
@property (strong, nonatomic) NSMutableAttributedString *gameHistory;
@end

@implementation CardMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUi];
    
}

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

- (NSMutableAttributedString *)lastMatchedText {
    if (!_lastMatchedText){
        _lastMatchedText = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    return _lastMatchedText;
}

- (NSMutableAttributedString *)gameHistory {
    if (!_gameHistory){
        _gameHistory  = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    return _gameHistory;
}

//ABSTRACT
- (Deck *)createDeck{
    return nil;
    //return [[PlayingCardDeck alloc] init];
}

//ABSTRACT
- (NSUInteger)getGameType {
    return 0;
//    NSString *title = [self.gameType titleForSegmentAtIndex:self.gameType.selectedSegmentIndex];
//    NSUInteger selected = [title integerValue];
//    NSLog(@"Getting the game type %lu", selected);
//    return selected;
    
}

- (IBAction)dealButton:(UIButton *)sender {
    [self newGame];
    [self updateUi];
}

- (IBAction)endGameButton:(UIButton *)sender {
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
    
    if (![turnMatches containsObject:drawnCard]){
        [turnMatches addObject:drawnCard];
    }
    [self setLastMatchedTextWithMatches:turnMatches
                               AndScore:turnScore];
    
    if (self.lastMatchedText.length > 0) [self updateGameHistory];
    
    [self updateUi];
}


- (void)setLastMatchedTextWithMatches:(NSArray *)turnMatches
                               AndScore:(NSInteger)turnScore {
    //NSString* matchTickerText = @"";
    NSMutableAttributedString* lastMatch = [[NSMutableAttributedString alloc] initWithString:@""];
    if (turnMatches.count == self.game.gameType){
        for (Card* card in turnMatches){
            [lastMatch appendAttributedString:[self illustrateCard:card]];
            [lastMatch appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            NSLog(@"Card drawing: %@", [self illustrateCard:card]);
            NSLog(@"Ticker Text: %@", lastMatch);
        }
        [lastMatch appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %d points", (turnScore > 0 ? @"Match! " : @"Don't Match!"), (int)turnScore]]];
    }
    //self.matchedTicker.text = matchTickerText;
    self.lastMatchedText = lastMatch;
}

- (void)updateGameHistory {
    [self.gameHistory appendAttributedString:self.lastMatchedText];
    [self.gameHistory appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    NSLog(@"History: %@", self.gameHistory);
}

- (void)updateUi{
    BOOL gameOver = self.game.isGameOver;
    //Update each card
    for (UIButton* cardButton in self.cardButtons){
        int index = (int)[self.cardButtons indexOfObject:cardButton];
        Card* card = [self.game cardAtIndex:index];
        [cardButton setAttributedTitle:[self titleForCard:card]
                              forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self imageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    //General Updates
    if (gameOver){
        self.score.text = [NSString stringWithFormat:@"Game Over! Score: %d", (int)self.game.score];
        self.lastMatchedText = [[NSMutableAttributedString alloc] initWithString:@""];
        self.dealButton.enabled = YES;
        //[self.gameType setEnabled:YES];
    }
    else {
        self.score.text = [NSString stringWithFormat:@"Score: %d", (int)self.game.score];
        self.dealButton.enabled = NO;
        //[self.gameType setEnabled:YES];
    }
    self.matchedTicker.attributedText = self.lastMatchedText;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:@"View Game History"]){
        if ([segue.destinationViewController isKindOfClass:[MatchHistoryViewController class]]){
            MatchHistoryViewController* mhVC = (MatchHistoryViewController *)segue.destinationViewController;
            mhVC.currentHistory = self.gameHistory;
        }
    }
}

//ABSTRACT
- (NSAttributedString *)illustrateCard:(Card *)card {
    return nil;
}

//ABSTRACT
- (NSAttributedString *)titleForCard:(Card *)card {
    return nil;
    //return card.isChosen ? card.contents : @"";
}

//ABSTRACT
- (UIImage *)imageForCard:(Card *)card {
    return nil;
    //return [UIImage imageNamed:card.isChosen ? @"card-front" : @"card-back"];
}


@end
