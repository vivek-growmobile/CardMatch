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
#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }


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

- (void)drawPips {
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont* pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
     pipFont = [pipFont fontWithSize:(pipFont.pointSize * [self cornerScaleFactor])];
    
    NSAttributedString* pipText = [[NSAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@", self.suit]];
    NSLog(@"piptext: %@", pipText);
    
    NSLog(@"Bounds width %f", self.bounds.size.width);
    CGRect pipRect = CGRectInset(self.bounds, self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    NSLog(@"piprect origin %@", NSStringFromCGPoint(pipRect.origin));
    pipRect.size = pipText.size;
    NSLog(@"piprect width %f", pipRect.size.width);
    NSLog(@"piprect height %f", pipRect.size.height);
    [pipText drawInRect:pipRect];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath* roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    [[UIColor blackColor] setStroke];
    [roundedRect fill];
    [roundedRect stroke];
    
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

@end
