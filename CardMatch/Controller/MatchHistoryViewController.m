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
    self.matchHistory.attributedText = self.currentHistory;
    NSLog(@"Match History Attr Text: %@",self.matchHistory.attributedText);
    
    // Do any additional setup after loading the view.
}

@end
