//
//  SetCard.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 5/7/14.
//  Copyright (c) 2014 Vivek Sivakumar. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard
@synthesize suit = _suit;

+ (NSArray *)validSymbols {
    return @[@"▲", @"●", @"■"];
}

+ (NSArray *)validRanks {
    return @[@"1", @"2", @"3"];
}

+ (NSArray *)validShades {
    return @[@"solid", @"striped", @"open"];
}

+ (NSArray *)validColors {
    return @[@"red", @"green", @"purple"];
}

- (void)setSymbol:(NSString *)suit {
//    if ([[SetCard validSuits] containsObject:suit]){
//        _suit = suit;
//    }
}

- (NSString *)symbol {
    return _suit ? _suit : @"?";
}

- (NSString *)contents {
    return self.suit;
}

- (int)match:(NSArray *)otherCards {
    int match = 0;
    for (SetCard* otherCard in otherCards) {
        if ([self.suit isEqualToString:otherCard.suit]){
            match += 1;
        }
    }
    return match;
}

@end
