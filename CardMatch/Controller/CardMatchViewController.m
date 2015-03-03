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
#import "CardView.h"

#import "MatchHistoryViewController.h"

@interface CardMatchViewController ()
@property (weak, nonatomic) IBOutlet UILabel *score;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *gameType;
@property (weak, nonatomic) IBOutlet UILabel *matchedTicker;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (strong, nonatomic) NSMutableAttributedString *lastMatchedText;
@property (strong, nonatomic) NSMutableAttributedString *gameHistory;
@end

@implementation CardMatchViewController

#pragma mark initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    [self newGame];
}

#define DEFAULT_NUM_CARDS 24
#define GRID_WIDTH 6
#define GRID_HEIGHT 4

- (void)newGame {
    self.game = [[CardMatchingGame alloc] initWithCardCount:DEFAULT_NUM_CARDS ofType:[self getGameType] usingDeck:[self createDeck]];
    [self initUi];
}

- (void)initUi {
    if (self.cardViews.count > 0){
        for (CardView* cardView in self.cardViews){
            [cardView removeFromSuperview];
        }
    }
    self.cardViews = [[NSMutableArray alloc] init];
    CGRect cardFrame = CGRectMake(self.cardTableView.bounds.origin.x, self.cardTableView.bounds.origin.y, self.cardTableView.bounds.size.width / GRID_WIDTH, self.cardTableView.bounds.size.height / GRID_HEIGHT);
    for (int i = 0; i < self.game.cards.count; i++){
        CardView* newCardView = [self createCardViewInFrame:cardFrame];
        [self.cardViews addObject:newCardView];
        [self.cardTableView addSubview:newCardView];
        cardFrame.origin.x = cardFrame.origin.x + (self.cardTableView.bounds.size.width / GRID_WIDTH);
        if (cardFrame.origin.x >= self.cardTableView.bounds.size.width){
            cardFrame.origin.x = self.cardTableView.bounds.origin.x;
            cardFrame.origin.y = cardFrame.origin.y + (self.cardTableView.bounds.size.height / GRID_HEIGHT);
        }
    }
    [self updateUi];
}


//ABSTRACT
- (CardView *)createCardViewInFrame:(CGRect)frame {
    return nil;
}


#pragma mark properties
- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:DEFAULT_NUM_CARDS ofType:[self getGameType] usingDeck:[self createDeck]];
    return _game;
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
}

//ABSTRACT
- (NSUInteger)getGameType {
    return 0;
//    NSString *title = [self.gameType titleForSegmentAtIndex:self.gameType.selectedSegmentIndex];
//    NSUInteger selected = [title integerValue];
//    NSLog(@"Getting the game type %lu", selected);
//    return selected;
    
}


#pragma mark UI Target-Action
- (IBAction)dealButton:(UIButton *)sender {
    [self newGame];
    //[self updateUi];
}

- (IBAction)endGameButton:(UIButton *)sender {
    [self.game endGame];
    [self updateUi];
}

- (IBAction)tapCardTable:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded){
        CGPoint tappedPoint = [gesture locationInView:self.cardTableView];
        UIView* tappedSubView = [self.cardTableView hitTest:tappedPoint withEvent:nil];
        if ([tappedSubView isKindOfClass:[CardView class]]){
            [self tapCardView:(CardView *)tappedSubView];
        }
    }
}

- (void)tapCardView:(CardView *)cardView{
    //Collect data before drawing card
    NSInteger oldScore = self.game.score;
    NSMutableArray *turnMatches = [[NSMutableArray alloc] initWithArray:self.game.matches];
    //DrawCard
    int index = (int)[self.cardViews indexOfObject:cardView];
    Card* drawnCard = [self.game chooseCardAtIndex:index];
    NSLog(@"Drawn Card: %@", drawnCard.contents);
    NSInteger newScore = self.game.score;
    NSInteger turnScore = newScore - oldScore;
    [self setLastMatchedTextWithMatches:turnMatches
                               AndScore:turnScore];
    
    if (self.lastMatchedText.length > 0) [self updateGameHistory];
    
    [self updateUi];
}

#pragma mark UI
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

//ABSTRACT
- (void)drawCard:(Card *)card
      onCardView:(CardView *)cardView {
    return;
}

//ABSTRACT
- (BOOL)cardView:(CardView *)cardView
       showsCard:(Card *)card {
    return NO;
}

- (void)updateUi{
    BOOL gameOver = self.game.isGameOver;
    //Update each card
    for (CardView* cardView in self.cardViews){
        int index = (int)[self.cardViews indexOfObject:cardView];
        Card* card = [self.game cardAtIndex:index];
        if ([self cardView:cardView showsCard:card] || ![cardView isDrawn]){
            [self drawCard:card
                onCardView:cardView];
        }
        else {
            [self animateReplacingCardView:cardView
                               withNewCard:card];
        }
        
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

//ABSTRACT
- (void)animateReplacingCardView:(CardView *)cardView
                          withNewCard:(Card *)newCard{
//    [UIView transitionWithView:cardView
//                      duration:1.0
//                       options:UIViewAnimationOptionTransitionCrossDissolve
//                    animations:^{
//                        [self drawCard:newCard
//                            onCardView:cardView];
//                    }
//                    completion:nil
//     ];
}

#pragma mark segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:@"View Game History"]){
        if ([segue.destinationViewController isKindOfClass:[MatchHistoryViewController class]]){
            MatchHistoryViewController* mhVC = (MatchHistoryViewController *)segue.destinationViewController;
            mhVC.currentHistory = self.gameHistory;
        }
    }
}



#pragma mark deprecate
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
