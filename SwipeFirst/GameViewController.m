//
//  GameViewController.m
//  SwipeFirst
//
//  Created by Student on 2015-03-12.
//  Copyright (c) 2015 CCHS. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //For the standard default "2 is on | 1 is off | 0 means it hasnt been set
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs integerForKey:@"audioOn"] != 0){
        //There is already a set boolean value
        if([prefs integerForKey:@"audioOn"] == 2){
            [self.button5 setBackgroundImage:[UIImage imageNamed: @"AudioOn.png"] forState:UIControlStateNormal];
        }else{
            [self.button5 setBackgroundImage:[UIImage imageNamed: @"AudioOff.png"] forState:UIControlStateNormal];
        }
    }else{
        [prefs setInteger: 2 forKey: @"audioOn"];
        [self.button5 setBackgroundImage:[UIImage imageNamed: @"AudioOn.png"] forState:UIControlStateNormal];
    }
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    [scene initializeViewController:self];
    
    //Added following code trying to set up game center
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthenticationViewController)
     name:PresentAuthenticationViewController
     object:nil];
    
    [[GameKitHelper sharedGameKitHelper]
     authenticateLocalPlayer];
}

- (void)showAuthenticationViewController
{
    GameKitHelper *gameKitHelper =
    [GameKitHelper sharedGameKitHelper];
    
    [self presentViewController:
     gameKitHelper.authenticationViewController
                                         animated:YES
                                       completion:nil];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (IBAction)sendCommandToScene:(id)sender {
    /*
    UIButton *button = (UIButton *)sender;
    NSString *buttonTitle = button.currentTitle;
    SKView *skView = (SKView *)self.view;
    SKScene *scene = skView.scene;
     */
    //CALL SOME METHOD HERE PASSING ALONG THE NAME OF THE COMMAND TO THE SCENE
    //[scene sendCommand: buttonTitle]; or something equivalent
    
}
- (IBAction)gamecenterButton:(id)sender {
    [self showLeaderboardAndAchievements:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs doubleForKey: [NSString stringWithFormat:@"HS%d",0]] != 0){
        NSLog(@"setting even odd leaderboard");
        [self setLeaderboard: @"evenoddleaderboard" withScore: ([prefs doubleForKey: [NSString stringWithFormat:@"HS%d",0]] * 100)];
    }
    if([prefs doubleForKey: [NSString stringWithFormat:@"HS%d",1]] != 0){
        NSLog(@"setting red black leaderboard");
        [self setLeaderboard: @"redblackleaderboard" withScore: ([prefs doubleForKey: [NSString stringWithFormat:@"HS%d",1]] * 100)];
    }
    if([prefs doubleForKey: [NSString stringWithFormat:@"HS%d",2]] != 0){
        NSLog(@"setting face number leaderboard");
        [self setLeaderboard: @"facenumberleaderboard" withScore: ([prefs doubleForKey: [NSString stringWithFormat:@"HS%d",2]] * 100)];
    }
    if([prefs doubleForKey: [NSString stringWithFormat:@"HS%d",3]] != 0 ){
        NSLog(@"setting setting shuffle leaderboard");
        [self setLeaderboard: @"shuffleleaderboard" withScore: ([prefs doubleForKey: [NSString stringWithFormat:@"HS%d",3]] * 100)];
    }
}
- (IBAction)audioButtonPressed:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs integerForKey:@"audioOn"] == 2){
        [sender setBackgroundImage:[UIImage imageNamed: @"AudioOff.png"] forState:UIControlStateNormal];
        [prefs setInteger: 1 forKey:@"audioOn"];
    }else{
        [sender setBackgroundImage:[UIImage imageNamed: @"AudioOn.png"] forState:UIControlStateNormal];
        [prefs setInteger: 2 forKey:@"audioOn"];
    }
    
}

-(void)hideButtons{
    NSLog(@"HIDE");
    self.button1.hidden = true;
    self.button2.hidden = true;
    self.button3.hidden = true;
    self.button4.hidden = true;
    self.button5.hidden = true;
}

-(void)showButtons{
    NSLog(@"SHOW");
    self.button1.hidden = false;
    self.button2.hidden = false;
    self.button3.hidden = false;
    self.button4.hidden = false;
    self.button5.hidden = false;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
