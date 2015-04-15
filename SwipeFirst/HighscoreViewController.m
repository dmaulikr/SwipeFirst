//
//  HighscoreViewController.m
//  SwipeFirst
//
//  Created by Jared Weinstein on 3/28/15.
//  Copyright (c) 2015 CCHS. All rights reserved.
//

#import "HighscoreViewController.h"

@interface HighscoreViewController ()

@end

@implementation HighscoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    double HS = [prefs doubleForKey: [NSString stringWithFormat:@"HS01"]];
    int minutes = (int)(HS / 60.0);
    double seconds = (double)((int)((HS - (minutes * 60)) * 10000)) / 10000;
    self.highscore1.text = [NSString stringWithFormat:@"%d:%07.4f", minutes, seconds];
        
    HS = [prefs doubleForKey: [NSString stringWithFormat:@"HS11"]];
    minutes = (int)(HS / 60.0);
    seconds = (double)((int)((HS - (minutes * 60)) * 10000)) / 10000;
    self.highscore2.text = [NSString stringWithFormat:@"%d:%07.4f", minutes, seconds];
    
    HS = [prefs doubleForKey: [NSString stringWithFormat:@"HS21"]];
    minutes = (int)(HS / 60.0);
    seconds = (double)((int)((HS - (minutes * 60)) * 10000)) / 10000;
    self.highscore3.text = [NSString stringWithFormat:@"%d:%07.4f", minutes, seconds];
    
    HS = [prefs doubleForKey: [NSString stringWithFormat:@"HS31"]];
    minutes = (int)(HS / 60.0);
    seconds = (double)((int)((HS - (minutes * 60)) * 10000)) / 10000;
    self.highscore4.text = [NSString stringWithFormat:@"%d:%07.4f", minutes, seconds];
    
    
    
    
    HS = [prefs doubleForKey: [NSString stringWithFormat:@"HS00"]];
    self.highscore5.text = [NSString stringWithFormat:@"%d", (int) HS];
    
    HS = [prefs doubleForKey: [NSString stringWithFormat:@"HS10"]];
    self.highscore6.text = [NSString stringWithFormat:@"%d", (int) HS];
    
    HS = [prefs doubleForKey: [NSString stringWithFormat:@"HS20"]];
    self.highscore7.text = [NSString stringWithFormat:@"%d", (int) HS];
    
    HS = [prefs doubleForKey: [NSString stringWithFormat:@"HS30"]];
    self.highscore8.text = [NSString stringWithFormat:@"%d", (int) HS];
    
    
    
    HS = [prefs doubleForKey: [NSString stringWithFormat:@"HS02"]];
    self.highscore9.text = [NSString stringWithFormat:@"%d", (int) HS];
    
    HS = [prefs doubleForKey: [NSString stringWithFormat:@"HS12"]];
    self.highscore10.text = [NSString stringWithFormat:@"%d", (int) HS];
    
    HS = [prefs doubleForKey: [NSString stringWithFormat:@"HS22"]];
    self.highscore11.text = [NSString stringWithFormat:@"%d", (int) HS];
    
    HS = [prefs doubleForKey: [NSString stringWithFormat:@"HS32"]];
    self.highscore12.text = [NSString stringWithFormat:@"%d", (int) HS];
    
    int totalCardsSwiped = (int)[prefs integerForKey: @"totalCardsSwiped"];
    int totalSwipedCorrectly = (int)[prefs integerForKey: @"totalSwipedCorrectly"];
    self.totalSwipedLabel.text =[NSString stringWithFormat:@"%d", totalCardsSwiped];
    if(totalCardsSwiped > 10){
        double percentage = ((int)(((double) totalSwipedCorrectly / (double) totalCardsSwiped) * 10000) / 100.0);
        self.accuracyLabel.text = [NSString stringWithFormat:@"%.2f%%", percentage];
    }else{
        self.accuracyLabel.text = @"n/a";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
