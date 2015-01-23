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

//Override
- (int)match:(NSArray *)otherCards {
    int match = 0;
    for (PlayingCard* otherCard in otherCards){
        if (self.rank == otherCard.rank){
            match += 4;
        }
        if ([self.suit isEqualToString:otherCard.suit]){
            match += 1;
        }
    }
    return match;
}

@end
