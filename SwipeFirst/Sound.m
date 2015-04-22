//
//  Sound.m
//  SwipeFirst
//
//  Created by Jared Weinstein on 4/20/15.
//  Copyright (c) 2015 CCHS. All rights reserved.
//

#import "Sound.h"

@implementation Sound

+(void) playSoundWithFileName: (NSString*) audioName{
    if([[NSUserDefaults standardUserDefaults] integerForKey: @"audioOn"] == 2){
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], audioName]];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops = 0;
        //if (audioPlayer == nil)
        //    NSLog(@"%@",[error description]);
        //else
        [audioPlayer play];
    }
}

+(void) playClick{
    if([[NSUserDefaults standardUserDefaults] integerForKey: @"audioOn"] != 1){
        NSLog(@"Play Click");
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/click.mp3", [[NSBundle mainBundle] resourcePath]]];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops = 0;
        [audioPlayer play];
    }
}

@end
