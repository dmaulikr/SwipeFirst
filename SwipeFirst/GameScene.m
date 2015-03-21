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
SKLabelNode *bottomLabel;
SKLabelNode *topSort;
SKLabelNode *bottomSort;
NSTimeInterval startTime;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    isPlaying = false;
    [self addLabels];
    deck = [[Deck alloc] init];
    CGPoint location = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    card = [[PlayingCard  alloc] initWithName: @"NAME"];
    card.xScale = 0.4;
    card.yScale = 0.4;
    card.position = location;
    [self addChild: card];
    [self addSwipeGestures];
    card.name = [[deck getRandomCard] name];
    //[card flip];
}

-(void) addLabels{
    topLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier New"]; //Curier is monospaced (almost) but looks shitty
    topLabel.text = @"Swipe First!";
    topLabel.fontSize = 40;
    topLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 145);
    [self addChild:topLabel];
    bottomLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier New"]; //Curier is monospaced (almost) but looks shitty
    bottomLabel.text = @"Swipe First!";
    bottomLabel.fontSize = 40;
    bottomLabel.position = CGPointMake(CGRectGetMidX(self.frame), 125);
    [self addChild:bottomLabel];
    topSort = [SKLabelNode labelNodeWithFontNamed:@"Courier New"];
    topSort.text = @"Red";
    topSort.fontSize = 20;
    topSort.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 25);
    [self addChild:topSort];
    bottomSort = [SKLabelNode labelNodeWithFontNamed:@"Courier New"];
    bottomSort.text = @"Black";
    bottomSort.fontSize = 20;
    bottomSort.position = CGPointMake(CGRectGetMidX(self.frame), 15);
    [self addChild:bottomSort];
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
        topSort.text = @"Even";
        bottomSort.text = @"Odd";
    }else{
        return;
    }
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)sender{
    NSLog(@"Swipe Right");
    if(!isPlaying){
        //NEED TO SWIPE THROUGH CATEGORIES
        topSort.text = @"Red";
        bottomSort.text = @"Black";
    }else{
        return;
    }
}


- (void)handleSwipeUp:(UISwipeGestureRecognizer *)sender{
    NSLog(@"Swipe Up");
    if(isPlaying == false){
        [card flip];
        isPlaying = true;
        startTime = [NSDate timeIntervalSinceReferenceDate];
    }else{
        if(card.isRed == true){
            PlayingCard *overlayCard;
            CGPoint location = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            overlayCard = [[PlayingCard  alloc] initWithName: card.name];
            overlayCard.xScale = 0.38;
            overlayCard.yScale = 0.38;
            overlayCard.position = location;
            [overlayCard flip];
            overlayCard.zPosition = 1; //Brings the sprite node to the front of all others
            [self addChild: overlayCard];
            SKAction *moveNodeUp = [SKAction moveByX:0.0 y:self.frame.size.height duration:.4];
            [overlayCard runAction: moveNodeUp];
            if([deck.arrayOfCards count] != 0){
                card.name = [[deck getRandomCard] name];
                [card update];
            }else{
                //END GAME
                [self resetGame];
            }
        }else{
            
        }
    }
    bottomLabel.text = [NSString stringWithFormat: @"%lu", (unsigned long)[deck.arrayOfCards count]];
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)sender{
    NSLog(@"Swipe Down");
    if(isPlaying == false){
        [card flip];
        isPlaying = true;
        startTime = [NSDate timeIntervalSinceReferenceDate];
    }else{
        if(card.isRed == false){
            PlayingCard *overlayCard;
            CGPoint location = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            overlayCard = [[PlayingCard  alloc] initWithName: card.name];
            overlayCard.xScale = 0.38;
            overlayCard.yScale = 0.38;
            overlayCard.position = location;
            [overlayCard flip];
            overlayCard.zPosition = 1; //Brings the sprite node to the front of all others
            [self addChild: overlayCard];
            SKAction *moveNodeDown = [SKAction moveByX:0.0 y:-self.frame.size.height duration:.4];
            [overlayCard runAction: moveNodeDown];
            if([deck.arrayOfCards count] != 0){
                card.name = [[deck getRandomCard] name];
                [card update];
            }else{
                //END GAME
                [self resetGame];
            }
        }else{
            
        }
    }
    bottomLabel.text = [NSString stringWithFormat: @"%lu", (unsigned long)[deck.arrayOfCards count]];
}

-(void) resetGame{
    deck = [[Deck alloc] init];
    [card flip];
    isPlaying = false;
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
    if(isPlaying == false)
        return;
    NSTimeInterval instantTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsedTime = instantTime - startTime;
    // We calculate the minutes.
    int minutes = (int)(elapsedTime / 60.0);
    // We calculate the seconds.
    double seconds = (double)((int)((elapsedTime - (minutes * 60)) * 10000)) / 10000;
    topLabel.text = [NSString stringWithFormat:@"%d:%.4f", minutes, seconds];
}

@end
