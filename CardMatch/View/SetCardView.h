//
//  SetCardView.h
//  CardMatch
//
//  Created by Vivek Sivakumar on 2/17/15.
//  Copyright (c) 2015 Vivek Sivakumar. All rights reserved.
//

#import "CardView.h"

@interface SetCardView : CardView

#pragma mark properties
@property (strong, nonatomic) NSString* number;
@property (strong, nonatomic) NSString* symbol;
@property (strong, nonatomic) NSString* shading;
@property (strong, nonatomic) NSString* color;
@property (nonatomic) BOOL chosen;
@end
