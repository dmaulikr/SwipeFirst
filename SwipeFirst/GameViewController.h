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

@interface GameViewController : GameCenterViewController

-(void) hideButtons;
-(void) showButtons;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;

@property bool *isAudioOn;


@end
