//
//  Sound.h
//  SwipeFirst
//
//  Created by Jared Weinstein on 4/20/15.
//  Copyright (c) 2015 CCHS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Sound : NSObject

+(void) playSoundWithFileName: (NSString*) audioName;
+(void) playClick;

@end

AVAudioPlayer *audioPlayer;