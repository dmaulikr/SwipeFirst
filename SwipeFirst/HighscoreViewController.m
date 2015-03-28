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
    
    double HS1 = [prefs doubleForKey: [NSString stringWithFormat:@"HS0"]];
    int minutes = (int)(HS1 / 60.0);
    double seconds = (double)((int)((HS1 - (minutes * 60)) * 10000)) / 10000;
    self.highscore1.text = [NSString stringWithFormat:@"%d:%07.4f", minutes, seconds];
        
    double HS2 = [prefs doubleForKey: [NSString stringWithFormat:@"HS1"]];
    minutes = (int)(HS2 / 60.0);
    seconds = (double)((int)((HS2 - (minutes * 60)) * 10000)) / 10000;
    self.highscore2.text = [NSString stringWithFormat:@"%d:%07.4f", minutes, seconds];
    
    double HS3 = [prefs doubleForKey: [NSString stringWithFormat:@"HS2"]];
    minutes = (int)(HS3 / 60.0);
    seconds = (double)((int)((HS3 - (minutes * 60)) * 10000)) / 10000;
    self.highscore3.text = [NSString stringWithFormat:@"%d:%07.4f", minutes, seconds];
    
    double HS4 = [prefs doubleForKey: [NSString stringWithFormat:@"HS3"]];
    minutes = (int)(HS4 / 60.0);
    seconds = (double)((int)((HS4 - (minutes * 60)) * 10000)) / 10000;
    self.highscore4.text = [NSString stringWithFormat:@"%d:%07.4f", minutes, seconds];
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
