//
//  GameCenterViewController.m
//  SwipeFirst
//
//  Created by Jared Weinstein on 3/28/15.
//  Copyright (c) 2015 CCHS. All rights reserved.
//

#import "GameCenterViewController.h"

@interface GameCenterViewController ()

@end

@implementation GameCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLeaderboardAndAchievements:YES];
    //Update the leaderboards for local data
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    
    //This method can be simplified substantially and could probably be moved to the GameScene
    if([prefs doubleForKey: [NSString stringWithFormat:@"HS%d",0]] != 0){
        NSLog(@"setting even odd leaderboard");
        [self setLeaderboard: @"evenoddleaderboard" withScore: ([prefs doubleForKey: [NSString stringWithFormat:@"HS%d",0]] * 100)];
    }
    if([prefs doubleForKey: [NSString stringWithFormat:@"HS%d",1]] != 0){
        NSLog(@"setting red black leaderboard");
        [self setLeaderboard: @"redblackleaderboard" withScore: ([prefs doubleForKey: [NSString stringWithFormat:@"HS%d",1]] * 100)];
    }
    if([prefs doubleForKey: [NSString stringWithFormat:@"HS%d",2]] != 0){
        NSLog(@"setting face number leaderboard");
        [self setLeaderboard: @"facenumberleaderboard" withScore: ([prefs doubleForKey: [NSString stringWithFormat:@"HS%d",2]] * 100)];
    }
    if([prefs doubleForKey: [NSString stringWithFormat:@"HS%d",3]] != 0 ){
        NSLog(@"setting setting shuffle leaderboard");
        [self setLeaderboard: @"shuffleleaderboard" withScore: ([prefs doubleForKey: [NSString stringWithFormat:@"HS%d",3]] * 100)];
    }
    // Do any additional setup after loading the view.
    [self showLeaderboardAndAchievements:YES];
}

-(void)setLeaderboard: (NSString*) identifier withScore: (double) val{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:identifier];
    score.value = val;
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if(error != nil){
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        //gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    [self presentViewController:gcViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
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
