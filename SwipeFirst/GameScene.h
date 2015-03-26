//
//  GameScene.h
//  SwipeFirst
//

//  Copyright (c) 2015 CCHS. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GameScene : SKScene

-(void) resetGame;
-(void) setGameMode: (NSString*) Mode;

@end

AVAudioPlayer *audioPlayer;
