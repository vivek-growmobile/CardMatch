//
//  MatchHistoryViewController.h
//  CardMatch
//
//  Created by Vivek Sivakumar on 2/2/15.
//  Copyright (c) 2015 Vivek Sivakumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchHistoryViewController : UIViewController

- (void)updateHistoryTo:(NSAttributedString *)currentHistory;
- (void)resetHistory;

@end
