//
//  Card.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 11/22/13.
//  Copyright (c) 2013 Vivek Sivakumar. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards {
    int match = 0;
    for (Card* card in otherCards){
        if ([card.contents isEqualToString:self.contents]) match += 1;
    }
    return match;
}
    
@end
