//
//  GameScene.m
//  SwipeFirst
//
//  Created by Student on 2015-03-12.
//  Copyright (c) 2015 CCHS. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

SKSpriteNode *sprite;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Swipe First!";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   self.frame.size.height - 65);
    
    [self addChild:myLabel];
    
    CGPoint location = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    sprite = [SKSpriteNode spriteNodeWithImageNamed:@"CardBack"];
    
    sprite.xScale = 0.5;
    sprite.yScale = 0.5;
    sprite.position = location;
    
    [self addChild:sprite];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [[self view] addGestureRecognizer:recognizer];
    
    UISwipeGestureRecognizer *recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    recognizer2.direction = UISwipeGestureRecognizerDirectionDown;
    [[self view] addGestureRecognizer:recognizer2];

}

- (void)handleSwipeUp:(UISwipeGestureRecognizer *)sender{
    NSLog(@"Swipe Up");
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)sender{
    NSLog(@"Swipe Down");
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInView: self.view];
        if([sprite containsPoint: location]){
            NSLog(@"CARD TAPPED");
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
