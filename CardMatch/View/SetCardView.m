//
//  SetCardView.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 2/17/15.
//  Copyright (c) 2015 Vivek Sivakumar. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#pragma mark initialization
- (void)setup {
    self.opaque = NO;
    self.backgroundColor = nil;
    [self setNeedsDisplay];
}

#pragma mark reference
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

#pragma mark translations
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

- (UIColor *)getColorFor:(NSString *)color {
    SEL colorMethodSelector = NSSelectorFromString([NSString stringWithFormat:@"%@Color", color]);
    return [UIColor performSelector:colorMethodSelector];
}

- (UIColor *)addShadingTo:(UIColor *)color {
    CGFloat cardShading = [self getFloatValueFor:self.shading];
    return [color colorWithAlphaComponent:cardShading];
}

#pragma mark properties
- (void)setNumber:(NSString *)number {
    _number = number;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSString *)symbol {
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading {
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)setChosen:(BOOL)chosen {
    _chosen = chosen;
    [self setNeedsDisplay];
}

#pragma mark drawing
#define VOFFSET_1 0.270
#define VOFFSET_2 0.175

- (void)drawSymbolWithVerticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically {
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont* symbolFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    symbolFont = [symbolFont fontWithSize:(3 * symbolFont.pointSize * [self cornerScaleFactor])];
    
    UIColor* shapeColor = [self addShadingTo:[self getColorFor:self.color]];
    
    NSAttributedString* symbolText = [[NSAttributedString alloc] initWithString:self.symbol attributes:@{NSFontAttributeName:symbolFont, NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName:shapeColor}];
    
    CGPoint symbolOrigin = CGPointMake(self.bounds.size.width / 2.0 - symbolText.size.width / 2.0, self.bounds.size.height / 2.0 - symbolText.size.height / 2.0);
    
    if (voffset) {
        symbolOrigin.y += voffset * self.bounds.size.height;
    }
    [symbolText drawAtPoint:symbolOrigin];

    if (mirroredVertically){
        symbolOrigin.y -= 2.0 * voffset * self.bounds.size.height;
        [symbolText drawAtPoint:symbolOrigin];
    }
    
}

- (void)drawCard {
    UIBezierPath* roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    UIColor* fillColor = self.chosen ? [UIColor grayColor] : [UIColor whiteColor];
    [fillColor setFill];
    [[UIColor blackColor] setStroke];
    [roundedRect fill];
    [roundedRect stroke];
}

- (void)drawCardImage {
    NSInteger number = [self.number integerValue];
    if (number == 1){
        [self drawSymbolWithVerticalOffset:0
                        mirroredVertically:NO];
    }
    else if (number == 2){
        [self drawSymbolWithVerticalOffset:VOFFSET_2
                        mirroredVertically:YES];
    }
    else if (number == 3){
        [self drawSymbolWithVerticalOffset:0
                        mirroredVertically:NO];
        [self drawSymbolWithVerticalOffset:VOFFSET_1
                        mirroredVertically:YES];
    }
}

@end
