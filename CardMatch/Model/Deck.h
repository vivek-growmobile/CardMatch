//
//  Deck.h
//  CardMatch
//
//  Created by Vivek Sivakumar on 11/22/13.
//  Copyright (c) 2013 Vivek Sivakumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject
- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;


- (Card *)drawRandomCard;
- (NSUInteger)cardsLeft;
@end
