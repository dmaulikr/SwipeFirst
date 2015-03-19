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

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    deck = [[Deck alloc] init];
    
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Times"];
    
    myLabel.text = @"Swipe First!";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   self.frame.size.height - 65);
    
    [self addChild:myLabel];
    
    CGPoint location = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    card = [[PlayingCard  alloc] initWithName: @"NAME"];
    
    card.xScale = 0.5;
    card.yScale = 0.5;
    card.position = location;
    
    [self addChild: card];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [[self view] addGestureRecognizer:recognizer];
    
    UISwipeGestureRecognizer *recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    recognizer2.direction = UISwipeGestureRecognizerDirectionDown;
    [[self view] addGestureRecognizer:recognizer2];
    
    card.name = [[deck getRandomCard] name];
    [card flip];

}

- (void)handleSwipeUp:(UISwipeGestureRecognizer *)sender{
    NSLog(@"Swipe Up");
    if(true /*make this is EVEN*/){
        card.name = [[deck getRandomCard] name];
        [card update];
    }else{
        
    }
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)sender{
    NSLog(@"Swipe Down");
    if(true /*make this is ODD*/){
        card.name = [[deck getRandomCard] name];
        [card update];
    }else{
        
    }
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
