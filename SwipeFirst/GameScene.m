//
//  GameScene.m
//  SwipeFirst
//
//  Created by Student on 2015-03-12.
//  Copyright (c) 2015 CCHS. All rights reserved.
//

#import "GameScene.h"
#import "PlayingCard.h"
#import "Deck.h"

@implementation GameScene

PlayingCard *card;
Deck *deck;
bool isPlaying;
SKLabelNode *topLabel;
NSTimeInterval startTime;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    isPlaying = false;
    
    deck = [[Deck alloc] init];
    topLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier New"]; //Curier is monospaced (almost) but looks shitty
    topLabel.text = @"Swipe First!";
    topLabel.fontSize = 40;
    topLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   self.frame.size.height - 65);
    [self addChild:topLabel];
    CGPoint location = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    card = [[PlayingCard  alloc] initWithName: @"NAME"];
    card.xScale = 0.5;
    card.yScale = 0.5;
    card.position = location;
    [self addChild: card];
    [self addSwipeGestures];
    card.name = [[deck getRandomCard] name];
    [card flip];
}

-(void) addSwipeGestures{
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [[self view] addGestureRecognizer:recognizer];
    
    UISwipeGestureRecognizer *recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    recognizer2.direction = UISwipeGestureRecognizerDirectionDown;
    [[self view] addGestureRecognizer:recognizer2];
    
    UISwipeGestureRecognizer *recognizer3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    recognizer3.direction = UISwipeGestureRecognizerDirectionRight;
    [[self view] addGestureRecognizer:recognizer3];
    
    UISwipeGestureRecognizer *recognizer4 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    recognizer4.direction = UISwipeGestureRecognizerDirectionLeft;
    [[self view] addGestureRecognizer:recognizer4];
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)sender{
    NSLog(@"Swipe Left");
    if(!isPlaying){
        //NEED TO SWIPER THROUGH CATEGORIES
        topLabel.text = @"Left";
    }else{
        return;
    }
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)sender{
    NSLog(@"Swipe Right");
    if(!isPlaying){
        //NEED TO SWIPE THROUGH CATEGORIES
        topLabel.text = @"Right";
    }else{
        return;
    }
}


- (void)handleSwipeUp:(UISwipeGestureRecognizer *)sender{
    NSLog(@"Swipe Up");
    if(isPlaying == false){
        isPlaying = true;
        startTime = [NSDate timeIntervalSinceReferenceDate];
        [self update];
    }else{
        if(true /*make this is EVEN*/){
            if([deck.arrayOfCards count] != 0){
                card.name = [[deck getRandomCard] name];
                [card update];
            }else{
                //END GAME
                isPlaying = false;
            }
        }else{
            
        }
    }
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)sender{
    NSLog(@"Swipe Down");
    if(isPlaying == false){
        isPlaying = true;
        startTime = [NSDate timeIntervalSinceReferenceDate];
        [self update];
    }else{
        if(true /*make this is ODD*/){
            if([deck.arrayOfCards count] != 0){
                card.name = [[deck getRandomCard] name];
                [card update];
            }else{
                //END GAME
                isPlaying = false;
            }
        }else{
            
        }
    }
}

-(void) update{
    if(isPlaying == false)
        return;
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsedTime = currentTime - startTime;
    // We calculate the minutes.
    int minutes = (int)(elapsedTime / 60.0);
    // We calculate the seconds.
    double seconds = (double)((int)((elapsedTime - (minutes * 60)) * 10000)) / 10000;
    topLabel.text = [NSString stringWithFormat:@"%d:%.4f", minutes, seconds];
[self performSelector:@selector(update) withObject:nil afterDelay:.05];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches){
        /*CGPoint location = [touch locationInNode: self];
        if([card containsPoint: location]){
            NSLog(@"CARD TAPPED");
            if(!card.isFrontFancing)
                card.name = [[deck getRandomCard] name];
            [card flip];
        }*/
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
