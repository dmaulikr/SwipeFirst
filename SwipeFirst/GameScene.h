//
//  GameScene.h
//  SwipeFirst
//

//  Copyright (c) 2015 CCHS. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GameViewController.h"
#import "Sound.h"

@interface GameScene : SKScene

-(void) resetGame;
-(void) initializeViewController: (UIViewController *) passedController;
-(void) updateCardFront;

@end

AVAudioPlayer *audioPlayer;
UIViewController *controller;