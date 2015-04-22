//
//  GameViewController.h
//  SwipeFirst
//

//  Copyright (c) 2015 CCHS. All rights reserved.

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "GameKitHelper.h"
#import "GameCenterViewController.h"
#import "Sound.h"

@interface GameViewController : GameCenterViewController

-(void) hideButtons;
-(void) showButtons;

@property (weak, nonatomic) IBOutlet UIImageView *play;
@property (weak, nonatomic) IBOutlet UIImageView *gameMode;
@property (weak, nonatomic) IBOutlet UIImageView *sortMode;


@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;

@property (weak, nonatomic) IBOutlet UIView *transparentView;
@property (weak, nonatomic) IBOutlet UIView *instructionsView;

@end
