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

+ (NSArray *)validSuits {
    return @[@"", @"", @""];
}

- (void)setSuit:(NSString *)suit {
    if ([[SetCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}

- (NSString *)suit {
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
