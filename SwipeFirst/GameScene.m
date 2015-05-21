//
//  GameScene.m
//  SwipeFirst
//
//  Created by Student on 2015-03-12.
//  Copyright (c) 2015 CCHS. All rights reserved.
//

/**
TODO LIST:
 - HW Images
 - Finish Sounds (wrong card sound and click)
 - Achievements
 - Error: what happens when gamecenter unlocked decks doesn't match the NSUserDefaults info
**/

#import "GameScene.h"
#import "PlayingCard.h"
#import "Deck.h"

@implementation GameScene

PlayingCard *card;
PlayingCard *nextCard;
Deck *deck;
bool isPlaying;
bool isEnd;
bool isShuffleMode = false;
SKLabelNode *topLabel;
SKLabelNode *bottomLabel;
SKSpriteNode *topSort;
SKSpriteNode *bottomSort;
SKSpriteNode *shuffleButton;
SKLabelNode *highscore;
SKLabelNode *highscoreDouble;
SKLabelNode *score;
SKLabelNode *scoreDouble;
//SKSpriteNode *background;
//SKSpriteNode *reallyBackBackground;
SKSpriteNode *backgroundRed;
SKSpriteNode *reallyBackBackgroundRed;
NSTimeInterval startTime;
double penalty = 0;
int sortMode = 1; // | 0 is even odd | 1 is red black | 2 is face non-face | 3 is shuffle
int gameMode = 1; // 0 is sprint | 1 is deck | 2 is marathon
int totalCardsSwiped;
int totalSwipedCorrectly;
int marathonBonusCount;
NSUserDefaults *prefs;
UIPanGestureRecognizer *recognizer5;

static NSString *FONT = @"Exo 2";


-(void)didMoveToView:(SKView *)view {
    prefs = [NSUserDefaults standardUserDefaults];
    /* Setup your scene here */
    marathonBonusCount = 0;
    
    if([prefs doubleForKey: [NSString stringWithFormat:@"totalCardsSwiped"]] != 0){
        totalCardsSwiped = [prefs doubleForKey: [NSString stringWithFormat:@"totalCardsSwiped"]];
    }if([prefs integerForKey: [NSString stringWithFormat:@"totalSwipedCorrectly"]] != 0){
        totalSwipedCorrectly = [prefs doubleForKey: [NSString stringWithFormat:@"totalSwipedCorrectly"]];
    }
    //self.backgroundColor = [UIColor lightGrayColor];
    isPlaying = false;
    [self addLabels];
    deck = [[Deck alloc] init];
    CGPoint location = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    nextCard = [[PlayingCard  alloc] initWithName: @"NAME"];
    [nextCard setPixelTexture];
    nextCard.xScale = 0.4;
    nextCard.yScale = 0.4;
    nextCard.position = location;
    [self addChild: nextCard];
    nextCard.name = [[deck getRandomCard: true] name];
    nextCard.zPosition = -1;
    
    
    card = [[PlayingCard  alloc] initWithName: @"NAME"];
    [card setPixelTexture];
    card.xScale = 0.4;
    card.yScale = 0.4;
    card.position = location;
    [self addChild: card];
    [self addSwipeGestures];
    card.name = [[deck getRandomCard: true] name];
    [nextCard flip];

    //[card flip];
    
    shuffleButton = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"play again.png"]];// color:[UIColor whiteColor] size:CGSizeMake(card.size.width - 10, card.size.height / 10)];
    shuffleButton.size = CGSizeMake(card.size.width, card.size.width / 5.628);
    [shuffleButton setPosition: CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 120)];
    shuffleButton.zPosition = -90;
    [self addChild: shuffleButton];
    
    [self updateLabels];
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithTexture: [SKTexture textureWithImageNamed:@"blueBackground.jpg"]];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.xScale = .4;//Guess and Check: Needs to be standardized for all screen sizes
    background.yScale = .4;
    background.zPosition = -99;
    [self addChild:background];
    SKSpriteNode *reallyBackBackground = [[SKSpriteNode alloc] initWithTexture: [SKTexture textureWithImageNamed:@"bigBlueBackground"]];
    reallyBackBackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    reallyBackBackground.xScale = 1;//Guess and Check: Needs to be standardized for all screen sizes
    reallyBackBackground.yScale = 1;
    reallyBackBackground.zPosition = -100;
    [self addChild:reallyBackBackground];
    
    backgroundRed = [[SKSpriteNode alloc] initWithTexture: [SKTexture textureWithImageNamed:@"redBackground.jpg"]];
    backgroundRed.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    backgroundRed.xScale = .4;//Guess and Check: Needs to be standardized for all screen sizes
    backgroundRed.yScale = .4;
    backgroundRed.zPosition = -97;
    [self addChild:backgroundRed];
    [backgroundRed setHidden: true];
    reallyBackBackgroundRed = [[SKSpriteNode alloc] initWithTexture: [SKTexture textureWithImageNamed:@"bigRedBackground"]];
    reallyBackBackgroundRed.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    reallyBackBackgroundRed.xScale = 1;//Guess and Check: Needs to be standardized for all screen sizes
    reallyBackBackgroundRed.yScale = 1;
    reallyBackBackgroundRed.zPosition = -98;
    [self addChild:reallyBackBackgroundRed];
    [reallyBackBackgroundRed setHidden: true];
}

-(void) initializeViewController: (GameViewController*) passedController{
    controller = passedController;
}

-(void) addLabels{
    topLabel = [SKLabelNode labelNodeWithFontNamed:FONT]; //Courier is monospaced (almost) but looks shitty
    topLabel.text = @"< Deck >";
    topLabel.fontSize = 40;
    topLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 130);
    [self addChild:topLabel];
    bottomLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier New Bold"]; //Courier is monospaced (almost) but looks shitty
    bottomLabel.text = @"";
    bottomLabel.fontSize = 40;
    bottomLabel.position = CGPointMake(CGRectGetMidX(self.frame), 110);
    [self addChild:bottomLabel];
    
    
    topSort = [[SKSpriteNode alloc] initWithTexture: [SKTexture textureWithImageNamed:@"red.png"]];
    topSort.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 30);
    topSort.xScale = 0.115;//Guess and Check: Needs to be standardized for all screen sizes
    topSort.yScale = 0.115;
    [self addChild:topSort];
    bottomSort = [[SKSpriteNode alloc] initWithTexture: [SKTexture textureWithImageNamed:@"black.png"]];
    bottomSort.position = CGPointMake(CGRectGetMidX(self.frame), 30);
    bottomSort.xScale = 0.115;//Guess and Check: Needs to be standardized for all screen sizes
    bottomSort.yScale = 0.115;
    [self addChild:bottomSort];
    
    
    score = [SKLabelNode labelNodeWithFontNamed:FONT];
    score.text = @"Score: ";
    score.fontSize = 30;
    score.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 120);
    [self addChild:score];
    [score setHidden: TRUE];
    scoreDouble = [SKLabelNode labelNodeWithFontNamed:@"Courier New Bold"];
    scoreDouble.text = @"";
    scoreDouble.fontSize = 40;
    scoreDouble.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 60);
    [self addChild:scoreDouble];
    [scoreDouble setHidden: TRUE];
    highscore = [SKLabelNode labelNodeWithFontNamed:FONT];
    highscore.text = @"Current Highscore: ";
    highscore.fontSize = 30;
    highscore.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:highscore];
    [highscore setHidden: TRUE];
    highscoreDouble = [SKLabelNode labelNodeWithFontNamed:@"Courier New Bold"];
    highscoreDouble.text = @"";
    highscoreDouble.fontSize = 40;
    highscoreDouble.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 60);
    [self addChild:highscoreDouble];
    [highscore setHidden: TRUE];
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
    
    recognizer5 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    recognizer5.minimumNumberOfTouches = 1;
    recognizer5.maximumNumberOfTouches = 1;
    [recognizer5 setEnabled: NO];
    [[self view] addGestureRecognizer:recognizer5];
}

-(void) handlePan: (UIPanGestureRecognizer*)sender{
    if(isPlaying){
        if(sender.state == UIGestureRecognizerStateEnded){
            NSLog(@"finished");
            NSLog(@"VELOCITY: %f", [sender velocityInView:self.view].y);
            if([sender velocityInView:self.view].y > 0){
                //Swipe up
                [self handleSwipe: (UIPanGestureRecognizer*) sender direction: 1];
            }else if([sender velocityInView:self.view].y == 0){ //Needs to be set to a <some value so that really slow back swipes dont count
                if(card.position.y < CGRectGetMidY(self.frame)){
                    [self handleSwipe: (UIPanGestureRecognizer*) sender direction: 1];
                }else{
                    [self handleSwipe: (UIPanGestureRecognizer*) sender direction: 0];
                }
            }else{
                [self handleSwipe: (UIPanGestureRecognizer*) sender direction: 0];
            }
        }else if(sender.state == UIGestureRecognizerStateCancelled){
            card.position = CGPointMake(card.position.x, CGRectGetMidY(self.frame));
        }else if(sender.state == UIGestureRecognizerStateChanged){
            int y = [sender translationInView:self.view].y / 1.5;
            card.position = CGPointMake(card.position.x, CGRectGetMidY(self.frame) - y);
        }
    }else{
        NSLog(@"Trying to swipe but game is not playing");
    }
}

-(void) handleSwipeLeft:(UISwipeGestureRecognizer *)sender{
    
    //NSLog(@"Swipe Left");
    if(!isPlaying){
        //NEED TO SWIPE THROUGH CATEGORIES
        CGPoint loc2 = [sender locationInView: self.view];
        NSLog(@"%f, %f", loc2.x, loc2.y);
        CGRect rect = topLabel.frame;
        NSLog(@"%f, %f", rect.origin.x, rect.origin.y);
        if(loc2.y > self.view.frame.size.height * .12 && loc2.y < self.view.frame.size.height*.20){
            NSLog(@"Swipe left on label");
            if(gameMode > 0){
                gameMode--;
                [self updateLabels];
            }
        } else if(sortMode != 0){
            sortMode--;
            [self handleSwipeAnimationWithDirection:-1];
        }
    }else{
        [self resetGame];
        return;
    }
}

-(void) handleSwipeRight:(UISwipeGestureRecognizer *)sender{
    //NSLog(@"Swipe Right");
    if(!isPlaying){
        //NEED TO SWIPE THROUGH CATEGORIES
        CGPoint loc2 = [sender locationInView: self.view];
        NSLog(@"%f", loc2.y);
        if (loc2.y > self.view.frame.size.height * .12 && loc2.y < self.view.frame.size.height*.20) {
            NSLog(@"Swipe right on label");
            if(gameMode < 2){
                gameMode++;
                [self updateLabels];
            }
        } else if(sortMode != 3){
            sortMode++;
            [self handleSwipeAnimationWithDirection:1];
        }
    }else{
        [self resetGame];
        return;
    }
}

-(void) updateSortMode{
    switch (sortMode) {
        case 0:
            [topSort setTexture: [SKTexture textureWithImageNamed:@"even.png"]];
            [bottomSort setTexture: [SKTexture textureWithImageNamed:@"odd.png"]];
            break;
        case 1:
            [topSort setTexture: [SKTexture textureWithImageNamed:@"red.png"]];
            [bottomSort setTexture: [SKTexture textureWithImageNamed:@"black.png"]];
            break;
        case 2:
            [topSort setTexture: [SKTexture textureWithImageNamed:@"face.png"]];
            [bottomSort setTexture: [SKTexture textureWithImageNamed:@"number.png"]];
            break;
        case 3:
            [topSort setTexture: [SKTexture textureWithImageNamed:@"shuffleTop.png"]];
            [bottomSort setTexture: [SKTexture textureWithImageNamed:@"shuffleBottom.png"]];
            break;
        default:
            break;
    }
}

-(void) updateLabels{
    //THIS IS CALLED EVERYTIME THE GAME SWITCHES

    switch (gameMode) {
        case 0:
            topLabel.text = @"< Sprint";
            break;
        case 1:
            topLabel.text = @"< Deck >";
            break;
        case 2:
            topLabel.text = @"Marathon >";
            break;
        default:
            break;
    }
}

-(void) handleSwipe: (UIGestureRecognizer *) sender direction: (int) dir {
    
    NSLog(@"%f", [sender locationInView:self.view].x);
    bool shouldUpdateBottomLabel = true;
    if(isPlaying == false && isEnd == false){
        [card flip];
        [recognizer5 setEnabled:true];
        topLabel.fontName = @"Courier New Bold";
        [(GameViewController *) controller hideButtons];
        isPlaying = true;
        startTime = [NSDate timeIntervalSinceReferenceDate];
        PlayingCard *overlayCard;
        CGPoint location = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        overlayCard = [[PlayingCard  alloc] initWithName: [card.name substringFromIndex:1]];
        overlayCard.xScale = 0.38;
        overlayCard.yScale = 0.38;
        overlayCard.position = location;
        overlayCard.zPosition = 1; //Brings the sprite node to the front of all others
        [self addChild: overlayCard];
        double twistAmount = (([sender locationOfTouch:0 inView:self.view].x - self.frame.size.width / 2) + self.view.center.x*2) / 100;
        SKAction *twistNode = [SKAction rotateByAngle:(twistAmount * ((dir == 0)? 1 : -1)) duration:.3];
        [overlayCard runAction: twistNode]; //NEEDS TO BE STANDARDIZED FOR ALL SCREEN SIZES CURRENTLY GUESS AND CHECK
        SKAction *moveNodeUp = [SKAction moveByX:0.0 y:(self.frame.size.height * ((dir == 0)? 1 : -1)) duration:.3];
        [overlayCard runAction: moveNodeUp];
        [Sound playSoundWithFileName:@"cardFlip.mp3"];
        if(sortMode == 3){
            isShuffleMode = true;
        }
        if([[card name] hasPrefix: @"4"]){
            [card setPixelTexture];
            [nextCard setPixelTexture];
        }
        if(isShuffleMode){
            sortMode = 0;
            [self updateSortMode];
        }
    }else if(isPlaying == true && isEnd == false){
        totalCardsSwiped++;
        if([self checkValidCardSwipe: (dir == 0)? @"up" : @"down"]){
            totalSwipedCorrectly++;
            PlayingCard *overlayCard;
            [overlayCard setPixelTexture];
            overlayCard = [[PlayingCard  alloc] initWithName: [card.name substringFromIndex:1]];
            overlayCard.xScale = 0.38;
            overlayCard.yScale = 0.38;
            overlayCard.position = card.position;
            [overlayCard flip];
            overlayCard.zPosition = 1; //Brings the sprite node to the front of all others
            [self addChild: overlayCard];
            double twistAmount = (([sender locationInView:self.view].x - self.frame.size.width / 2) + self.view.center.x*2) / 100;
            SKAction *twistNode = [SKAction rotateByAngle:(twistAmount * ((dir == 0)? 1 : -1)) duration:.3];
            [overlayCard runAction: twistNode]; //NEEDS TO BE STANDARDIZED FOR ALL SCREEN SIZES CURRENTLY GUESS AND CHECK
            SKAction *moveNodeUp = [SKAction moveByX:0.0 y:self.frame.size.height * ((dir == 0)? 1 : -1) duration:.3];
            [overlayCard runAction: moveNodeUp];
            card.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            [Sound playSoundWithFileName:@"cardFlip.mp3"];
            if([deck.arrayOfCards count] > 0){
                NSLog(@"COUNT GREATER THAN 1");
                card.name = nextCard.name;
                nextCard.name = [[deck getRandomCard: gameMode == 1] name];
                
                if(gameMode == 2 && deck.numTaken%10 == 0){
                    penalty -=(10 - 0.5 * marathonBonusCount);  
                    marathonBonusCount++;
                }
                [card update];
                [nextCard update];
                if([[card name] hasPrefix: @"4"]){
                    [card setPixelTexture];
                    [nextCard setPixelTexture];
                }
            }else if(gameMode == 1 && ([deck.arrayOfCards count] == 0) && [nextCard isHidden] == false){
                NSLog(@"COUNT EQUALS 1");
                card.name = nextCard.name;
                [nextCard setHidden: true];
                if(gameMode == 2 && deck.numTaken%10 == 0){
                    penalty -=(10 - 0.5 * marathonBonusCount);
                    marathonBonusCount++;
                }
                [card update];
                bottomLabel.text = [NSString stringWithFormat:@"%d", (int)([deck.arrayOfCards count] + 1)];
                shouldUpdateBottomLabel = false;
                //[nextCard update];
                if([[card name] hasPrefix: @"4"])
                    [card setPixelTexture];
            }else if(gameMode == 1){
                NSLog(@"COUNT EQUALS ZERO");
                //END GAME
                [self endGame];
            }
            if(isShuffleMode){
                sortMode = (sortMode+1)%3;
                [self updateSortMode];
            }
        }else{
            NSLog(@"PENALTY");
            penalty += 1;
            [card runAction:[SKAction moveToY: CGRectGetMidY(self.frame) duration:0]];
            //self.backgroundColor = [UIColor redColor];
            [backgroundRed setHidden: false];
            [reallyBackBackgroundRed setHidden: false];
            //reallyBackBackground.texture = [SKTexture textureWithImageNamed:@"bigRedBackground"];
            //background.texture = [SKTexture textureWithImageNamed:@"redBackground.jpg"];
            [Sound playSoundWithFileName:@"wrongCard.mp3"];
            [self performSelector:@selector(resetAfterPenalty) withObject:self afterDelay:.3];
            if(gameMode == 2){
                [self endGame];
            }
        }
    }
    if(shouldUpdateBottomLabel)
        bottomLabel.text = [NSString stringWithFormat: @"%lu", (gameMode == 1)? ((unsigned long)[deck.arrayOfCards count] + 1) : (unsigned long)[deck numTaken]];
}

-(void) handleSwipeUp:(UISwipeGestureRecognizer *)sender{
    [self handleSwipe: sender direction: 0];
}

-(void) handleSwipeDown:(UISwipeGestureRecognizer *)sender{
    [self handleSwipe:sender direction: 1];
}

-(void) shuffleAnimation{
    for(int i = 0; i < 5; i++){
        int randomXStartLocation = ((arc4random() % (int)self.frame.size.width) / 2) + (((int)self.frame.size.width) / 4);
        NSLog(@"Random Location: %d", randomXStartLocation);
        PlayingCard *newPlayingCard;
        newPlayingCard = [[PlayingCard  alloc] initWithName: card.name];
        if(randomXStartLocation % 2 == 1){
            newPlayingCard.position = CGPointMake(randomXStartLocation, -self.frame.size.height);
        }else{
            newPlayingCard.position = CGPointMake(randomXStartLocation, self.frame.size.height * 2);
        }
        newPlayingCard.xScale = .4;
        newPlayingCard.yScale = .4;
        newPlayingCard.zPosition = 1; //Brings the sprite node to the front of all others
        [self addChild: newPlayingCard];
        double twistAmount = (int)(arc4random() % 100) / 50 - 1;
        newPlayingCard.zRotation = twistAmount;
        SKAction *twistNode = [SKAction rotateToAngle:0 duration:.7];
        [newPlayingCard runAction: twistNode]; //NEEDS TO BE STANDARDIZED FOR ALL SCREEN SIZES CURRENTLY GUESS AND CHECK
        SKAction *moveNodeToCenter = [SKAction moveTo:CGPointMake((self.frame.size.width / 2), (self.frame.size.height / 2)) duration: .7];
        [Sound playSoundWithFileName:@"shuffle.mp3"];
        [newPlayingCard runAction: moveNodeToCenter];
        [newPlayingCard runAction:moveNodeToCenter completion:^{
            [newPlayingCard removeFromParent];
        }];
    }
}

-(void) handleSwipeAnimationWithDirection: (int) dir{
    SKAction *moveNodeOffScreen = [SKAction moveToX:self.frame.size.width * ((dir == -1)? 0 : 1) duration:.3];
    [topSort runAction: moveNodeOffScreen];
    [bottomSort runAction: moveNodeOffScreen];
    
    
    SKSpriteNode *topSortNew = [[SKSpriteNode alloc] initWithTexture: [SKTexture textureWithImageNamed:@"red.png"]];
    topSortNew.position = CGPointMake(self.frame.size.width * ((dir == -1)? 1 : 0), self.frame.size.height - 30);
    topSortNew.xScale = 0.115;
    topSortNew.yScale = 0.115;
    [self addChild:topSortNew];
    SKSpriteNode *bottomSortNew = [[SKSpriteNode alloc] initWithTexture: [SKTexture textureWithImageNamed:@"black.png"]];
    bottomSortNew.position = CGPointMake(self.frame.size.width * ((dir == -1)? 1 : 0), 30);
    bottomSortNew.xScale = 0.115;
    bottomSortNew.yScale = 0.115;
    [self addChild:bottomSortNew];

    switch (sortMode) {
        case 0:
            [topSortNew setTexture: [SKTexture textureWithImageNamed:@"even.png"]];
            [bottomSortNew setTexture: [SKTexture textureWithImageNamed:@"odd.png"]];
            break;
        case 1:
            [topSortNew setTexture: [SKTexture textureWithImageNamed:@"red.png"]];
            [bottomSortNew setTexture: [SKTexture textureWithImageNamed:@"black.png"]];
            break;
        case 2:
            [topSortNew setTexture: [SKTexture textureWithImageNamed:@"face.png"]];
            [bottomSortNew setTexture: [SKTexture textureWithImageNamed:@"number.png"]];
            break;
        case 3:
            [topSortNew setTexture: [SKTexture textureWithImageNamed:@"shuffleTop.png"]];
            [bottomSortNew setTexture: [SKTexture textureWithImageNamed:@"shuffleBottom.png"]];
            break;
        default:
            break;
    }
    
    SKAction *moveNodeOnScreen = [SKAction moveToX:(CGRectGetMidX(self.frame)) duration:.3];
    [topSortNew runAction: moveNodeOnScreen];
    [bottomSortNew runAction: moveNodeOnScreen];
    
    topSort = topSortNew;
    bottomSort = bottomSortNew;
}

-(void) endGame{
    [prefs setInteger:[prefs integerForKey:@"gamesPlayed"]+1 forKey:@"gamesPlayed"];
    marathonBonusCount = 0;
    [highscore setHidden: FALSE];
    [highscoreDouble setHidden: FALSE];
    [score setHidden: FALSE];
    [scoreDouble setHidden: FALSE];
    topLabel.fontName = FONT;
    scoreDouble.text = (gameMode == 1)? topLabel.text : [NSString stringWithFormat: @"%d", deck.numTaken];
    topLabel.text = @"Card Sort";
    
    [card setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [nextCard setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [nextCard setHidden: true];
    [card setHidden:true];
    isPlaying = false;
    isEnd = true;
    if(isShuffleMode == true){
        sortMode = 3;
        [self updateSortMode];
    }
    isShuffleMode = false;
    double currentScore = (gameMode == 1)? ([NSDate timeIntervalSinceReferenceDate] - startTime) + penalty : [deck numTaken];
    NSLog(@"Current Score at the end of the game is: %f", currentScore);
    if([prefs doubleForKey: [NSString stringWithFormat:@"HS%d%d",sortMode, gameMode]] != 0){
        double currentHS = [prefs doubleForKey: [NSString stringWithFormat:@"HS%d%d",sortMode,gameMode]];
        NSLog(@"Current HS at the end of the game is: %f", currentHS);
        if((gameMode == 1)? currentScore < currentHS : currentScore > currentHS){
            //New Highscore
            NSLog(@"Setting the new highscore");
            //self.backgroundColor = [UIColor greenColor]; //This color is absolutely disgusting
            highscore.text = @"Previous Highscore";
            [prefs setDouble:currentScore forKey:[NSString stringWithFormat:@"HS%d%d",sortMode, gameMode]];
        }else{
            NSLog(@"Did not set a new highscore");
            highscore.text = @"Current Highscore";
        }
        if(gameMode == 1){
            int minutes = (int)(currentHS / 60.0);
            double seconds = (double)((int)((currentHS - (minutes * 60)) * 10000)) / 10000;
            highscoreDouble.text = [NSString stringWithFormat:@"%d:%07.4f", minutes, seconds];
        }else{
            highscoreDouble.text = [NSString stringWithFormat:@"%d", (int) currentHS];
        }
    }else{
        NSLog(@"No current highscore");
        highscore.text = @"New Highscore";
        highscoreDouble.text = @"";
        [prefs setDouble:currentScore forKey:[NSString stringWithFormat:@"HS%d%d",sortMode, gameMode]];
    }
    
    [prefs setInteger: totalCardsSwiped forKey: @"totalCardsSwiped"];
    [prefs setInteger: totalSwipedCorrectly forKey: @"totalSwipedCorrectly"];
    
    [self updateAchievements];
     [(GameViewController *) controller updateAllLeaderboards];
}

-(void) updateAchievements{
    int totalCardsSwiped = (int)[prefs integerForKey: @"totalCardsSwiped"];
    int totalSwipedCorrectly = (int)[prefs integerForKey: @"totalSwipedCorrectly"];
    double gamesPlayed = (int)[prefs integerForKey:@"gamesPlayed"];
    double percentage = ((int)(((double) totalSwipedCorrectly / (double) totalCardsSwiped) * 10000) / 100.0);
    
    [self setAchievement: @"deck2unlocked" toDoubleValue:[prefs doubleForKey: [NSString stringWithFormat:@"HS11"]]*100/30];
    [self setAchievement: @"deck3unlocked" toDoubleValue:[prefs doubleForKey: [NSString stringWithFormat:@"HS10"]]*100/69];
    [self setAchievement: @"deck4unlocked" toDoubleValue:[prefs doubleForKey: [NSString stringWithFormat:@"HS12"]]*100/200];

    
    [self setAchievement:@"10games" toDoubleValue:gamesPlayed*10];
    [self setAchievement:@"25games" toDoubleValue:gamesPlayed*4];
    [self setAchievement:@"50games" toDoubleValue:gamesPlayed*2];
    [self setAchievement:@"100games" toDoubleValue:gamesPlayed];
    [self setAchievement:@"500games" toDoubleValue:gamesPlayed/5];
    [self setAchievement:@"1000games" toDoubleValue:gamesPlayed/10];
    
    [self setAchievement: @"500cards" toDoubleValue:totalCardsSwiped/5];
    [self setAchievement: @"1000cards" toDoubleValue:totalCardsSwiped/10];
    [self setAchievement: @"5000cards" toDoubleValue:totalCardsSwiped/50];
    [self setAchievement: @"10000cards" toDoubleValue:totalCardsSwiped/100];
    [self setAchievement: @"50000cards" toDoubleValue:totalCardsSwiped/500];
    
    double maxSprint = [prefs doubleForKey: [NSString stringWithFormat:@"HS11"]]/80;
    double sprint2 = [prefs doubleForKey: [NSString stringWithFormat:@"HS01"]]/80;
    if(maxSprint < sprint2) maxSprint = sprint2;
    double sprint3 = [prefs doubleForKey: [NSString stringWithFormat:@"HS21"]]/80;
    if(maxSprint < sprint3) maxSprint = sprint3;
    [self setAchievement: @"sprint80" toDoubleValue:maxSprint*100];
    
    [self setAchievement: @"marathon300" toDoubleValue:[prefs doubleForKey: [NSString stringWithFormat:@"HS12"]]/300]; //Add marathon mode scores for other sorts
    double maxMarathon = [prefs doubleForKey: [NSString stringWithFormat:@"HS12"]]/300;
    double marathon2 = [prefs doubleForKey: [NSString stringWithFormat:@"HS02"]]/300;
    if(maxMarathon < marathon2) maxMarathon = marathon2;
    double marathon3 = [prefs doubleForKey: [NSString stringWithFormat:@"HS22"]]/300;
    if(maxMarathon < marathon3) maxMarathon = marathon3;
    [self setAchievement: @"marathon300" toDoubleValue:maxMarathon*100];
    
    double maxDeck = 20/[prefs doubleForKey: [NSString stringWithFormat:@"HS11"]];
    double deck2 = 20/[prefs doubleForKey: [NSString stringWithFormat:@"HS01"]];
    if(maxDeck < deck2) maxDeck = deck2;
    double deck3 = 20/[prefs doubleForKey: [NSString stringWithFormat:@"HS21"]];
    if(maxDeck < deck3) maxDeck = deck3;
    
    [self setAchievement: @"deck20" toDoubleValue:maxDeck*100];
    
    double maxShuffle = 25/[prefs doubleForKey: [NSString stringWithFormat:@"HS31"]];
    double sprintShuffle = [prefs doubleForKey: [NSString stringWithFormat:@"HS30"]]/60;
    if(maxShuffle < sprintShuffle) maxShuffle = sprintShuffle;
    double marathonShuffle = [prefs doubleForKey: [NSString stringWithFormat:@"HS32"]]/150;
    if(maxShuffle < marathonShuffle) maxShuffle = marathonShuffle;
    
    [self setAchievement: @"shuffle" toDoubleValue:maxShuffle*100];

    if(totalCardsSwiped > 100){
        [self setAchievement:@"75accuracy" toDoubleValue:(percentage/75)*100];
        [self setAchievement:@"95accuracy" toDoubleValue:(percentage/95)*100];
    }

}

-(void) resetAfterPenalty{
    //ERROR: THIS ENDS FOR THE NEAREST PENALTY TWO IN QUICK SUCCESSION WILL END EARLY
    NSLog(@"RESET");
    //Called half a second after each penalty
    //self.backgroundColor = [UIColor lightGrayColor];
    [backgroundRed setHidden: true];
    [reallyBackBackgroundRed setHidden: true];
    //reallyBackBackground.texture = [SKTexture textureWithImageNamed:@"bigBlueBackground"];
    //background.texture = [SKTexture textureWithImageNamed:@"blueBackground.jpg"];
}

-(BOOL) checkValidCardSwipe: (NSString*) direction{
    NSLog(@"%d", sortMode);
    switch (sortMode) {
        case 0:
            //Even
            if([direction isEqualToString:@"up"]){
                return card.isEven;
            }else if([direction isEqualToString:@"down"]){
                return !card.isEven;
            }
            break;
        case 1:
            //Color
            if([direction isEqualToString:@"up"]){
                return card.isRed;
            }else if([direction isEqualToString:@"down"]){
                return !card.isRed;
            }
            break;
        case 2:
            //Face
            if([direction isEqualToString:@"up"]){
                return card.isFace;
            }else if([direction isEqualToString:@"down"]){
                return !card.isFace;
            }
            break;
        default:
            break;
    }
    NSLog(@"ERROR: should not have reached this line in checkValidCardSwipe");
    return false;
}

-(void) resetGame{
    [self shuffleAnimation];
    [self performSelector:@selector(moveToNewGame) withObject:self afterDelay:.6];
}

-(void) moveToNewGame{
    [recognizer5 setEnabled:false];
    [(GameViewController*) controller showButtons];
    //self.backgroundColor = [UIColor lightGrayColor];
    deck = [[Deck alloc] init];
    //topLabel.text = @"< Deck >";
    bottomLabel.text = @" ";
    isPlaying = false;
    
    switch (gameMode) {
        case 0:
            topLabel.text = @"< Sprint";
            break;
        case 1:
            topLabel.text = @"< Deck >";
            break;
        case 2:
            topLabel.text = @"Marathon >";
            break;
        default:
            break;
    }
    
    isEnd = false;
    penalty = 0;
    card.name = [[deck getRandomCard: true] name];
    [highscoreDouble setHidden: TRUE];
    [highscore setHidden: TRUE];
    [scoreDouble setHidden: TRUE];
    [score setHidden: TRUE];
    [card flip];
    [nextCard setHidden: false];
    [card setHidden: false];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInNode: self];
        if([shuffleButton containsPoint: location] && isEnd && !isPlaying){
            NSLog(@"RESET TAPPED");
            isEnd = false;
            [self resetGame];
        }
    }
}

-(void) setAchievement: (NSString*) identifier toDoubleValue: (double) val{
    [GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error)
    {
        GKAchievement *achieve = [[GKAchievement alloc] initWithIdentifier:identifier];
        bool hasBeenCompleted = false;
        if(error != NULL) { /* error handling */ }
        for (GKAchievement* achievement in scores) {
            if([achievement.identifier isEqualToString:identifier]){
                if(achievement.completed == true){
                    hasBeenCompleted = true;
                    NSLog(@"ACHIEVEMENT COMPLETED");
                }
            }
        }
        if (hasBeenCompleted == false){
            NSLog(@"HAS NOT BEEN ACHIEVED BEFORE: %@", identifier);
            [achieve setShowsCompletionBanner:true];
            achieve.percentComplete = val;
            [achieve setPercentComplete:val];
            [GKAchievement reportAchievements:@[achieve] withCompletionHandler:^(NSError *error) {
                if(error != nil){
                    NSLog(@"%@", [error localizedDescription]);
                }
            }];
        }else{
            NSLog(@"HAS BEEN ACHIEVED ALREADY %@", identifier);
            [achieve setShowsCompletionBanner:false];
        }
    }];
}

-(void) update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if(isPlaying == false)
        return;
    if(gameMode == 0){
        NSTimeInterval instantTime = [NSDate timeIntervalSinceReferenceDate];
        NSTimeInterval elapsedTime = instantTime - startTime;
        elapsedTime += penalty;
        // We calculate the minutes.
        int minutes = 0;
        // We calculate the seconds.
        double seconds = 30 - (double)((int)((elapsedTime - (minutes * 60)) * 10000)) / 10000;
        if(seconds <= 0){
            topLabel.text = [NSString stringWithFormat: @"%d Cards Swiped!", deck.numTaken];
            [self endGame];
        } else {
            topLabel.text = [NSString stringWithFormat:@"%d:%07.4f", minutes, seconds];
        }
        }
    if(gameMode == 1){
        NSTimeInterval instantTime = [NSDate timeIntervalSinceReferenceDate];
        NSTimeInterval elapsedTime = instantTime - startTime;
        elapsedTime += penalty;
        // We calculate the minutes.
        int minutes = (int)(elapsedTime / 60.0);
        // We calculate the seconds.
        double seconds = (double)((int)((elapsedTime - (minutes * 60)) * 10000)) / 10000;
        topLabel.text = [NSString stringWithFormat:@"%d:%07.4f", minutes, seconds];
    }
    if(gameMode == 2){
        NSTimeInterval instantTime = [NSDate timeIntervalSinceReferenceDate];
        NSTimeInterval elapsedTime = instantTime - startTime;
        elapsedTime += penalty;
        elapsedTime += 20;
        // We calculate the minutes.
        int minutes = 0;
        // We calculate the seconds.
        double seconds = 30 - (double)((int)((elapsedTime - (minutes * 60)) * 10000)) / 10000;
        if(seconds <= 0){
            topLabel.text = [NSString stringWithFormat: @"%d Cards Swiped!", deck.numTaken];
            [self endGame];
        } else {
            topLabel.text = [NSString stringWithFormat:@"%d:%07.4f", minutes, seconds];
        }
    }
}

@end
