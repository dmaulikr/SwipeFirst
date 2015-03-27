//
//  GameScene.h
//  SwipeFirst
//

//  Copyright (c) 2015 CCHS. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GameViewController.h"

@interface GameScene : SKScene

-(void) resetGame;
-(void) initializeViewController: (UIViewController *) passedController;

@end

AVAudioPlayer *audioPlayer;
UIViewController *controller;