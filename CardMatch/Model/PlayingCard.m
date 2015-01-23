//
//  PlayingCard.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 11/22/13.
//  Copyright (c) 2013 Vivek Sivakumar. All rights reserved.
//

#import "PlayingCard.h"
@interface PlayingCard()

@end

@implementation PlayingCard
@synthesize suit = _suit;

+ (NSArray *)validSuits {
    return @[@"♠", @"♣", @"♥", @"♦"];
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4",@"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
    return [[PlayingCard rankStrings] count] - 1;
}

- (NSString *)contents {
    return [[PlayingCard rankStrings][self.rank]  stringByAppendingString:self.suit];
    
}

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]){
        _rank = rank;
    }
}

//Helper method for just matching 2 playing cards
- (int)matchCards:(PlayingCard *)card1
              And:(PlayingCard *)card2 {
    int match = 0;
    if (card1.rank == card2.rank) match += 4;
    if ([card1.suit isEqualToString:card2.suit]) match += 1;
    return match;
}

//Override
- (int)match:(NSArray *)cards {
    int match = 0;
    for (int i = 0; i < cards.count - 1; i++){
        for (int j = 1; j < cards.count; j++){
            match += [self matchCards:cards[i]And:cards[j]];
        }
    }
    return match;
}

@end
