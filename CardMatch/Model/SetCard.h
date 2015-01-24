//
//  SetCard.h
//  CardMatch
//
//  Created by Vivek Sivakumar on 5/7/14.
//  Copyright (c) 2014 Vivek Sivakumar. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card
@property (strong, nonatomic) NSString* number;
@property (strong, nonatomic) NSString* symbol;
@property (strong, nonatomic) NSString* shading;
@property (strong, nonatomic) NSString* color;

+ (NSArray *)validNumbers;
+ (NSArray *)validSymbols;
+ (NSArray *)validShades;
+ (NSArray *)validColors;

@end
