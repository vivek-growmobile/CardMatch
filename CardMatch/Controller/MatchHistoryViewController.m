//
//  MatchHistoryViewController.m
//  CardMatch
//
//  Created by Vivek Sivakumar on 2/2/15.
//  Copyright (c) 2015 Vivek Sivakumar. All rights reserved.
//

#import "MatchHistoryViewController.h"

@interface MatchHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *matchHistory;

@end


@implementation MatchHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.matchHistory.editable = NO;
    
    // Do any additional setup after loading the view.
}


- (void)updateHistoryTo:(NSAttributedString *)currentHistory{
    NSLog(@"Current History: %@", currentHistory);
    self.matchHistory.attributedText = currentHistory;
    NSLog(@"Match History Attr Text: %@",self.matchHistory.attributedText);
}

- (void)resetHistory {
    self.matchHistory.attributedText = [[NSAttributedString alloc] initWithString:@""];
    //TODO
    //self.matchHistory.textStorage = @"";
}




@end
