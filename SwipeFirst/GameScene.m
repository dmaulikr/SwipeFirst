//
//  GameScene.m
//  SwipeFirst
//
//  Created by Student on 2015-03-12.
//  Copyright (c) 2015 CCHS. All rights reserved.
//

/**
TODO LIST:
 - "Swipe to begin"
 - Add Images
 - Different GameModes
 - Finish all Sounds
 - Error: If you swipe a card while the animation is running everything gets flipped
 - Add the last Deck
 - Error: change the category move to a new view controller then come back. Labels update to the same categories.
**/

#import "GameScene.h"
#import "PlayingCard.h"
#import "Deck.h"

@implementation GameScene

PlayingCard *card;
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
NSTimeInterval startTime;
double penalty = 0;
int sortMode = 1; // | 0 is even odd | 1 is red black | 2 is face non-face | 3 is shuffle
int gameMode = 1; // 0 is sprint | 1 is deck | 2 is marathon
int totalCardsSwiped;
int totalSwipedCorrectly;


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs doubleForKey: [NSString stringWithFormat:@"totalCardsSwiped"]] != 0){
        totalCardsSwiped = [prefs doubleForKey: [NSString stringWithFormat:@"totalCardsSwiped"]];
    }if([prefs integerForKey: [NSString stringWithFormat:@"totalSwipedCorrectly"]] != 0){
        totalSwipedCorrectly = [prefs doubleForKey: [NSString stringWithFormat:@"totalSwipedCorrectly"]];
    }
    self.backgroundColor = [UIColor darkGrayColor];
    isPlaying = false;
    [self addLabels];
    deck = [[Deck alloc] init];
    CGPoint location = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    card = [[PlayingCard  alloc] initWithName: @"NAME"];
    [card setPixelTexture];
    card.xScale = 0.4;
    card.yScale = 0.4;
    card.position = location;
    [self addChild: card];
    [self addSwipeGestures];
    card.name = [[deck getRandomCard] name];
    //[card flip];
    
    shuffleButton = [[SKSpriteNode alloc] initWithColor: [UIColor whiteColor] size:CGSizeMake(card.size.width - 10, card.size.height / 10)];
    [shuffleButton setPosition: CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 120)];
    [self addChild: shuffleButton];
}

-(void) initializeViewController: (GameViewController*) passedController{
    controller = passedController;
}

-(void) addLabels{
    topLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier New"]; //Curier is monospaced (almost) but looks shitty
    topLabel.text = @"Game Mode";
    topLabel.fontSize = 40;
    topLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 145);
    [self addChild:topLabel];
    bottomLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier New"]; //Curier is monospaced (almost) but looks shitty
    bottomLabel.text = @"";
    bottomLabel.fontSize = 40;
    bottomLabel.position = CGPointMake(CGRectGetMidX(self.frame), 135);
    [self addChild:bottomLabel];
    
    
    topSort = [[SKSpriteNode alloc] initWithTexture: [SKTexture textureWithImageNamed:@"red.png"]];
    topSort.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 30);
    topSort.xScale = 0.23;//Guess and Check: Needs to be standardized for all screen sizes
    topSort.yScale = 0.23;
    [self addChild:topSort];
    bottomSort = [[SKSpriteNode alloc] initWithTexture: [SKTexture textureWithImageNamed:@"black.png"]];
    bottomSort.position = CGPointMake(CGRectGetMidX(self.frame), 30);
    bottomSort.xScale = 0.23;//Guess and Check: Needs to be standardized for all screen sizes
    bottomSort.yScale = 0.23;
    [self addChild:bottomSort];
    
    
    score = [SKLabelNode labelNodeWithFontNamed:@"Courier New"];
    score.text = @"Score: ";
    score.fontSize = 30;
    score.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 120);
    [self addChild:score];
    [score setHidden: TRUE];
    scoreDouble = [SKLabelNode labelNodeWithFontNamed:@"Courier New"];
    scoreDouble.text = @"";
    scoreDouble.fontSize = 40;
    scoreDouble.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 60);
    [self addChild:scoreDouble];
    [scoreDouble setHidden: TRUE];
    highscore = [SKLabelNode labelNodeWithFontNamed:@"Courier New"];
    highscore.text = @"Current Highscore: ";
    highscore.fontSize = 30;
    highscore.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:highscore];
    [highscore setHidden: TRUE];
    highscoreDouble = [SKLabelNode labelNodeWithFontNamed:@"Courier New"];
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
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)sender{
    [self setAchievement: @"deck2unlocked" toDoubleValue:100];
    //NSLog(@"Swipe Left");
    if(!isPlaying){
        //NEED TO SWIPE THROUGH CATEGORIES
        CGPoint loc = [sender locationOfTouch:0 inView: self.view];
        NSLog(@"%f, %f", loc.x, loc.y);
        CGRect rect = topLabel.frame;
        NSLog(@"%f, %f", rect.origin.x, rect.origin.y);
        if(CGRectContainsPoint(topLabel.frame, loc)){ //This isn't correct, the points aren't lining up right
            NSLog(@"Swipe left on label");
        } else if(sortMode != 0){
            sortMode--;
        }
        [self updateLabels];
    }else{
        return;
    }
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)sender{
    //NSLog(@"Swipe Right");
    if(!isPlaying){
        //NEED TO SWIPE THROUGH CATEGORIES
        CGPoint loc = [sender locationOfTouch:0 inView: self.view];
        if (CGRectContainsPoint(topLabel.frame, loc)) {
            NSLog(@"Swipe right on label");
        } else if(sortMode != 3){
            sortMode++;
        }
        [self updateLabels];
    }else{
        return;
    }
}

-(void) updateLabels{
    //THIS IS CALLED EVERYTIME THE GAME SWITCHES
    NSLog(@"%d", sortMode);
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

-(void) handleSwipe: (UISwipeGestureRecognizer *) sender direction: (int) dir {
    
    NSLog(@"%f", [sender locationInView:self.view].x);
    if(isPlaying == false && isEnd == false){
        [card flip];
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
        [self playSoundWithFileName:@"cardFlip.mp3"];
        if(sortMode == 3){
            isShuffleMode = true;
        }
        if(isShuffleMode){
            sortMode = 0;
            [self updateLabels];
        }
    }else if(isPlaying == true && isEnd == false){
        totalCardsSwiped++;
        if([self checkValidCardSwipe: (dir == 0)? @"up" : @"down"]){
            totalSwipedCorrectly++;
            PlayingCard *overlayCard;
            [overlayCard setPixelTexture];
            CGPoint location = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            overlayCard = [[PlayingCard  alloc] initWithName: [card.name substringFromIndex:1]];
            overlayCard.xScale = 0.38;
            overlayCard.yScale = 0.38;
            overlayCard.position = location;
            [overlayCard flip];
            overlayCard.zPosition = 1; //Brings the sprite node to the front of all others
            [self addChild: overlayCard];
            double twistAmount = (([sender locationOfTouch:0 inView:self.view].x - self.frame.size.width / 2) + self.view.center.x*2) / 100;
            SKAction *twistNode = [SKAction rotateByAngle:(twistAmount * ((dir == 0)? 1 : -1)) duration:.3];
            [overlayCard runAction: twistNode]; //NEEDS TO BE STANDARDIZED FOR ALL SCREEN SIZES CURRENTLY GUESS AND CHECK
            SKAction *moveNodeUp = [SKAction moveByX:0.0 y:self.frame.size.height * ((dir == 0)? 1 : -1) duration:.3];
            [overlayCard runAction: moveNodeUp];
            [self playSoundWithFileName:@"cardFlip.mp3"];
            if([deck.arrayOfCards count] != 0){
                card.name = [[deck getRandomCard] name];
                [card update];
            }else{
                //END GAME
                [self endGame];
            }
            if(isShuffleMode){
                sortMode = (sortMode+1)%3;
                [self updateLabels];
            }
        }else{
            NSLog(@"PENALTY");
            penalty += 1;
            self.backgroundColor = [UIColor redColor];
            [self playSoundWithFileName:@"wrongCard.mp3"];
            [self performSelector:@selector(resetAfterPenalty) withObject:self afterDelay:.2];
        }
    }
    bottomLabel.text = [NSString stringWithFormat: @"%lu", (unsigned long)[deck.arrayOfCards count]];
}

- (void)handleSwipeUp:(UISwipeGestureRecognizer *)sender{
    [self handleSwipe: sender direction: 0];
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)sender{
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
        [self playSoundWithFileName:@"shuffle.mp3"];
        [newPlayingCard runAction: moveNodeToCenter];
        [newPlayingCard runAction:moveNodeToCenter completion:^{
            [newPlayingCard removeFromParent];
        }];
    }

}

-(void) endGame{
    [highscore setHidden: FALSE];
    [highscoreDouble setHidden: FALSE];
    [score setHidden: FALSE];
    [scoreDouble setHidden: FALSE];
    scoreDouble.text = topLabel.text;
    topLabel.text = @"Card Sort";
    
    [card setHidden:true];
    isPlaying = false;
    isEnd = true;
    if(isShuffleMode == true){
        sortMode = 3;
        [self updateLabels];
    }
    isShuffleMode = false;
    [self setAchievement: @"startthegame" toDoubleValue:100];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSTimeInterval currentScore = ([NSDate timeIntervalSinceReferenceDate] - startTime) + penalty;
    NSLog(@"Current Score at the end of the game is: %f", currentScore);
    if([prefs doubleForKey: [NSString stringWithFormat:@"HS%d%d",sortMode, gameMode]] != 0){
        double currentHS = [prefs doubleForKey: [NSString stringWithFormat:@"HS%d%d",sortMode,gameMode]];
        NSLog(@"Current HS at the end of the game is: %f", currentHS);
        if(currentScore < currentHS){
            //New Highscore
            NSLog(@"Setting the new highscore");
            self.backgroundColor = [UIColor greenColor]; //This color is absolutely disgusting
            highscore.text = @"Previous Highscore";
            [prefs setDouble:currentScore forKey:[NSString stringWithFormat:@"HS%d%d",sortMode, gameMode]];
        }else{
            NSLog(@"Did not set a new highscore");
            highscore.text = @"Current Highscore";
        }
        int minutes = (int)(currentHS / 60.0);
        double seconds = (double)((int)((currentHS - (minutes * 60)) * 10000)) / 10000;
        highscoreDouble.text = [NSString stringWithFormat:@"%d:%07.4f", minutes, seconds];
    }else{
        NSLog(@"No current highscore");
        highscore.text = @"New Highscore";
        highscoreDouble.text = @"";
        [prefs setDouble:currentScore forKey:[NSString stringWithFormat:@"HS%d%d",sortMode, gameMode]];
    }
    
    [prefs setInteger: totalCardsSwiped forKey: @"totalCardsSwiped"];
    [prefs setInteger: totalSwipedCorrectly forKey: @"totalSwipedCorrectly"];
}

-(void) resetAfterPenalty{
    //ERROR: THIS ENDS FOR THE NEAREST PENALTY TWO IN QUICK SUCCESSION WILL END EARLY
    NSLog(@"RESET");
    //Called half a second after each penalty
    self.backgroundColor = [UIColor darkGrayColor];
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
    [self performSelector:@selector(moveToNewGame) withObject:self afterDelay:.7];
}

-(void) moveToNewGame{
    [(GameViewController*) controller showButtons];
    self.backgroundColor = [UIColor darkGrayColor];
    deck = [[Deck alloc] init];
    topLabel.text = @"Game Mode";
    bottomLabel.text = @" ";
    isPlaying = false;
    isEnd = false;
    penalty = 0;
    card.name = [[deck getRandomCard] name];
    [highscoreDouble setHidden: TRUE];
    [highscore setHidden: TRUE];
    [scoreDouble setHidden: TRUE];
    [score setHidden: TRUE];
    [card flip];
    [card setHidden: false];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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

-(void) playSoundWithFileName: (NSString*) audioName{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], audioName]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    //if (audioPlayer == nil)
    //    NSLog(@"%@",[error description]);
    //else
    [audioPlayer play];
}

-(void) setAchievement: (NSString*) identifier toDoubleValue: (double) val{
    GKAchievement *achieve = [[GKAchievement alloc] initWithIdentifier:identifier];
    [achieve setShowsCompletionBanner:true];
    achieve.percentComplete = val;
    [achieve setPercentComplete:val];
    [GKAchievement reportAchievements:@[achieve] withCompletionHandler:^(NSError *error) {
        if(error != nil){
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if(isPlaying == false)
        return;
    NSTimeInterval instantTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsedTime = instantTime - startTime;
    elapsedTime += penalty;
    // We calculate the minutes.
    int minutes = (int)(elapsedTime / 60.0);
    // We calculate the seconds.
    double seconds = (double)((int)((elapsedTime - (minutes * 60)) * 10000)) / 10000;
    topLabel.text = [NSString stringWithFormat:@"%d:%07.4f", minutes, seconds];
}

@end
