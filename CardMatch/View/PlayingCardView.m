//
//  PlayingCardView.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 2/6/15.
//  Copyright (c) 2015 Vivek Sivakumar. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation PlayingCardView

#pragma mark properties
@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.9

- (CGFloat)faceCardScaleFactor {
    if (!_faceCardScaleFactor){
        _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    }
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor {
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCardView validSuits] containsObject:suit]){
        _suit = suit;
        [self setNeedsDisplay];
    }
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCardView maxRank]){
        _rank = rank;
        [self setNeedsDisplay];
    }
}

- (void)setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#pragma mark reference
+ (NSArray *)validSuits {
    return @[@"♠", @"♣", @"♥", @"♦"];
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4",@"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
    return [[PlayingCardView rankStrings] count] - 1;
}

- (NSString *)rankAsString {
    return [PlayingCardView rankStrings][self.rank];
}

#pragma mark loading
- (void)setup {
    self.opaque = NO;
    self.backgroundColor = nil;
    [self setNeedsDisplay];
}

#pragma mark drawing
- (void)drawCorners {
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont* cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:(cornerFont.pointSize * [self cornerScaleFactor])];
    
    NSAttributedString* cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@\n",[self rankAsString], self.suit] attributes:@{NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle}];
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = cornerText.size;
    [cornerText drawInRect:textBounds];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
    [cornerText drawInRect:textBounds];
    
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically {
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:NO];
    
    if (mirroredVertically){
        [self drawPipsWithHorizontalOffset:hoffset
                            verticalOffset:voffset
                                upsideDown:YES];
    }
    //TODO
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown {
    if (upsideDown){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
        CGContextRotateCTM(context, M_PI);
    }
    UIFont* pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    pipFont = [pipFont fontWithSize:(pipFont.pointSize * [self cornerScaleFactor])];
    
    NSAttributedString* pipText = [[NSAttributedString alloc]initWithString: self.suit
                                                                 attributes:@{NSFontAttributeName: pipFont}];
    CGSize pipSize = pipText.size;
    
    CGPoint middle = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    CGFloat originX = middle.x - (hoffset * self.bounds.size.width) - (pipSize.width / 2.0);
    if (hoffset) NSLog(@"x: %f", originX);
    CGFloat originY = middle.y - (voffset * self.bounds.size.height) - (pipSize.height / 2.0);
    
    CGPoint pipOrigin = CGPointMake(originX, originY);
    [pipText drawAtPoint:pipOrigin];
    
    if (hoffset) {
        CGFloat originMirroredX = middle.x + (hoffset * self.bounds.size.width)  - (pipSize.width / 2.0);
        if (hoffset) NSLog(@"mirrored x: %f", originMirroredX);
        CGFloat originMirroredY = pipOrigin.y;
        CGPoint pipOriginMirrored = CGPointMake(originMirroredX, originMirroredY);
        [pipText drawAtPoint:pipOriginMirrored];
    }
    if (upsideDown){
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    }
    
}

#define HOFFSET 0.165
#define VOFFSET_1 0.270
#define VOFFSET_2 0.175
#define VOFFSET_3 0.090


- (void)drawPips {
    //Middle pip
    if (self.rank == 1 || self.rank == 3 || self.rank == 5 || self.rank == 9){
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    
    //2 horizontally centered vertically mirrored pips
    if (self.rank == 2 || self.rank == 3){
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:VOFFSET_1 mirroredVertically:YES];
    }
    
    // 2 vertically centered horizintally mirrored pips
    if (self.rank == 6 || self.rank == 7 || self.rank == 8){
        [self drawPipsWithHorizontalOffset:HOFFSET
                            verticalOffset:0
                        mirroredVertically:NO];
    }

    //4 corner pips
    if (self.rank == 4 || self.rank == 5 || self.rank == 6 || self.rank == 7 || self.rank == 8 || self.rank == 9 || self.rank == 10) {
        [self drawPipsWithHorizontalOffset:HOFFSET
                            verticalOffset:VOFFSET_1
                            mirroredVertically:YES];
    }
    
    //1 or 2 Middle vertical pips
    if (self.rank == 7 || self.rank == 8 || self.rank == 10){
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:VOFFSET_2
                        mirroredVertically:(self.rank != 7)];
    }
    
    //4 Middle pips
    if (self.rank == 9 || self.rank == 10){
        [self drawPipsWithHorizontalOffset:HOFFSET
                            verticalOffset:VOFFSET_3
                        mirroredVertically:YES];
    }
    
}

- (void)drawCardImage {
    if (self.faceUp){
        UIImage* faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",[self rankAsString], self.suit]];
        if (faceImage){
            CGRect imageRect = CGRectInset(self.bounds, self.bounds.size.width * (1.0 - self.faceCardScaleFactor), self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
            [faceImage drawInRect:imageRect];
        }
        else {
            [self drawPips];
        }
        
        [self drawCorners];
    }
    else {
        UIImage* backImage = [UIImage imageNamed:@"card-back"];
        [backImage drawInRect:self.bounds];
    }
}

- (BOOL)isDrawn {
    return self.suit && self.rank;
}

@end
