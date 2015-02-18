//
//  SetMatchViewController.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 5/6/14.
//  Copyright (c) 2014 Vivek Sivakumar. All rights reserved.
//

#import "SetMatchViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "setCardView.h"

@interface SetMatchViewController ()

@end

@implementation SetMatchViewController

//Override
- (CardView *)createCardViewInFrame:(CGRect)frame {
    return [[SetCardView alloc] initWithFrame:frame];
}

//Override
- (NSUInteger)getGameType {
    NSLog(@"Getting Set Card Game Type");
    NSUInteger gameType = 3;
    return gameType;
}

//Override
- (Deck *)createDeck {
    NSLog(@"Creating Set Card Deck");
    return [[SetCardDeck alloc] init];
}

//Override
- (void)drawCard:(Card *)card
      onCardView:(CardView *)cardView {
    if ([card isKindOfClass:[SetCard class]]){
        SetCard* setCard = (SetCard *)card;
        if ([cardView isKindOfClass:[SetCardView class]]){
            SetCardView *setCardView = (SetCardView *)cardView;
            setCardView.number = setCard.number;
            setCardView.symbol = setCard.symbol;
            setCardView.shading = setCard.shading;
            setCardView.color = setCard.color;
            setCardView.chosen = setCard.chosen;
        }
    }
}

- (CGFloat)getFloatValueFor:(NSString *)shading {
    if ([shading isEqualToString:@"solid"]){
        return 1;
    }
    else if ([shading isEqualToString:@"striped"]){
        return 0.5;
    }
    else if ([shading isEqualToString:@"open"]){
        return 0.2;
    }
    else {
        return 1;
    }
}

//Override
- (NSAttributedString *)illustrateCard:(Card *)card {
    NSMutableAttributedString* title = [[NSMutableAttributedString alloc] initWithString:@""];
    
    SetCard* setCard = (SetCard*)card;
    
    //Draw the Number of Symbols
    int numSymbols = [setCard.number intValue];
    for (int i = 0; i < numSymbols; i++){
        [title appendAttributedString:[[NSAttributedString alloc] initWithString:
                                       [NSString stringWithFormat:@"%@ ", setCard.symbol]]];
    }
    
    //Set the Colors
    SEL colorMethodSelector = NSSelectorFromString([NSString stringWithFormat:@"%@Color",setCard.color]);
    UIColor* cardColor = [UIColor performSelector:colorMethodSelector];
    
    //Set Shading
    CGFloat cardShading = [self getFloatValueFor:setCard.shading];
    cardColor = [cardColor colorWithAlphaComponent:cardShading];
    [title addAttribute:NSForegroundColorAttributeName
                  value:cardColor
                  range:NSMakeRange(0, title.length)];
    
    //return card.contents;
    return title;
}

//Override
- (NSAttributedString *)titleForCard:(Card *)card {
    return [self illustrateCard:card];
}

//Override
- (UIImage *)imageForCard:(Card *)card {    
    return [UIImage imageNamed:card.isChosen? @"set-card-chosen" : @"card-front"];
}


@end
