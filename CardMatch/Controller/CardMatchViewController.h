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

@interface CardMatchViewController : UIViewController

//FOR SUBCLASSES
- (Deck *)createDeck;
- (NSUInteger)getGameType;
- (NSAttributedString *)titleForCard:(Card *)card;
- (UIImage *)imageForCard:(Card *)card;

@end
