//
//  SetCardDeck.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 5/7/14.
//  Copyright (c) 2014 Vivek Sivakumar. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype) init {
    self = [super init];
    if (self){
        for (NSString* number in [SetCard validNumbers]){
            for (NSString* symbol in [SetCard validSymbols]){
                for (NSString* shading in [SetCard validShades]){
                    for (NSString* color in [SetCard validColors]){
                        SetCard* newCard = [[SetCard alloc] init];
                        newCard.color = color;
                        newCard.shading = shading;
                        newCard.symbol = symbol;
                        newCard.number = number;
                        [self addCard:newCard];
                    }
                }
            }
        }
    }
    return self;
}
@end
