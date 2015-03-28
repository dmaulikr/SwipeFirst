//
//  GameCenterViewController.h
//  SwipeFirst
//
//  Created by Jared Weinstein on 3/28/15.
//  Copyright (c) 2015 CCHS. All rights reserved.
//

#import <GameKit/GameKit.h>

@interface GameCenterViewController : UIViewController <GKGameCenterControllerDelegate>

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard;

@end
