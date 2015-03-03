//
//  CardMatchViewController.h
//  CardMatch
//
//  Created by Vivek Sivakumar on 11/21/13.
//  Copyright (c) 2013 Vivek Sivakumar. All rights reserved.
//
// ABSTRACT CLASS. Must Implement methods as described below.

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"
#import "CardView.h"

@interface CardMatchViewController : UIViewController

#pragma mark public methods
@property (weak, nonatomic) IBOutlet UIView *cardTableView;
@property (strong, nonatomic) NSMutableArray* cardViews;
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) Deck *deck;

//FOR SUBCLASSES
#pragma mark abstract
- (CardView *)createCardViewInFrame:(CGRect)frame;
- (Deck *)createDeck;
- (NSUInteger)getGameType;
- (void)drawCard:(Card *)card
      onCardView:(CardView *)cardView;
- (BOOL)cardView:(CardView *)cardView
       showsCard:(Card *)card;
- (void)animateReplacingCardView:(CardView *)cardView
                     withNewCard:(Card *)newCard;

#pragma mark deprecate?
//DEPRECATE?
- (NSAttributedString *)illustrateCard:(Card *)card;
- (NSAttributedString *)titleForCard:(Card *)card;
- (UIImage *)imageForCard:(Card *)card;

@end
