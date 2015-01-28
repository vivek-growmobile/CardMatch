//
//  SetCard.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 5/7/14.
//  Copyright (c) 2014 Vivek Sivakumar. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard
@synthesize number  = _number;
@synthesize symbol  = _symbol;
@synthesize shading = _shading;
@synthesize color   = _color;


+ (NSArray *)validNumbers {
    return @[@"1", @"2", @"3"];
}

+ (NSArray *)validSymbols {
    return @[@"▲", @"●", @"■"];
}

+ (NSArray *)validShades {
    return @[@"solid", @"striped", @"open"];
}

+ (NSArray *)validColors {
    return @[@"red", @"green", @"purple"];
}

+ (int)setSize {
    return [SetCard validNumbers].count;
}

- (NSString *)contents {
    NSString* contents = [NSString stringWithFormat:@"[%@ %@ %@ %@]", self.number, self.symbol, self.shading, self.color];
    return contents;
    
}

- (void)setNumber:(NSString *)number {
    if ([[SetCard validNumbers] containsObject:number]){
        _number = number;
    }
}

- (void)setSymbol:(NSString *)symbol {
    if ([[SetCard validSymbols] containsObject:symbol]){
        _symbol = symbol;
    }
}

- (void)setShading:(NSString *)shading {
    if ([[SetCard validShades] containsObject:shading]){
        _shading = shading;
    }
}

- (void)setColor:(NSString *)color {
    if ([[SetCard validColors] containsObject:color]){
        _color = color;
    }
}

//Override
- (int)match:(NSArray *)cards {
    //Optimize?
    NSMutableSet* numbersSeen = [[NSMutableSet alloc] init];
    NSMutableSet* symbolsSeen = [[NSMutableSet alloc] init];
    NSMutableSet* shadesSeen = [[NSMutableSet alloc] init];
    NSMutableSet* colorsSeen = [[NSMutableSet alloc] init];
    NSArray* elementsSeen = @[numbersSeen, symbolsSeen, shadesSeen, colorsSeen];
    
    for (SetCard* card in cards){
        [numbersSeen addObject:card.number];
        [symbolsSeen addObject:card.symbol];
        [shadesSeen addObject:card.shading];
        [colorsSeen addObject:card.color];
    }
    
    int match = 0;
    for (NSSet* elementSet in elementsSeen){
        
        if (elementSet.count == [SetCard setSize]){
            match += cards.count;
        }
    }
    return match;
}

@end
