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

GameScene* scene;

@implementation GameViewController

- (void)viewDidLoad
{
    NSLog(@"VIEW DID LOAD IN GAMEVIEWCONTROLLER");
    [super viewDidLoad];
    
    self.button1.translatesAutoresizingMaskIntoConstraints = true;
    self.button2.translatesAutoresizingMaskIntoConstraints = true;
    self.button3.translatesAutoresizingMaskIntoConstraints = true;
    self.button4.translatesAutoresizingMaskIntoConstraints = true;
    self.button5.translatesAutoresizingMaskIntoConstraints = true;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]/* && false*/)
    {
        // app already launched
        [self backgroundPressed: self.button4];
    }
    else
    {
        //First launch ever
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    //For the standard default "2 is on | 1 is off | 0 means it hasnt been set
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs integerForKey:@"audioOn"] != 0){
        //There is already a set boolean value
        if([prefs integerForKey:@"audioOn"] == 2){
            [self.button5 setBackgroundImage:[UIImage imageNamed: @"audioon"] forState:UIControlStateNormal];
        }else{
            [self.button5 setBackgroundImage:[UIImage imageNamed: @"audiooff"] forState:UIControlStateNormal];
        }
    }else{
        [prefs setInteger: 2 forKey: @"audioOn"];
        [self.button5 setBackgroundImage:[UIImage imageNamed: @"audioon"] forState:UIControlStateNormal];
    }
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    scene = [GameScene unarchiveFromFile:@"GameScene"];
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
    
    _button1.frame = CGRectMake(self.view.frame.size.width/12, 4*self.view.frame.size.height/5, self.view.frame.size.width/6, self.view.frame.size.width/6);
    
    _button2.frame = CGRectMake(self.view.frame.size.width/12 + self.view.frame.size.width/6, 4*self.view.frame.size.height/5, self.view.frame.size.width/6, self.view.frame.size.width/6);
    
    _button3.frame = CGRectMake(self.view.frame.size.width/12 + 2*self.view.frame.size.width/6, 4*self.view.frame.size.height/5, self.view.frame.size.width/6, self.view.frame.size.width/6);
    
    _button4.frame = CGRectMake(self.view.frame.size.width/12 + 3*self.view.frame.size.width/6, 4*self.view.frame.size.height/5, self.view.frame.size.width/6, self.view.frame.size.width/6);
    
    _button5.frame = CGRectMake(self.view.frame.size.width/12 + 4*self.view.frame.size.width/6, 4*self.view.frame.size.height/5, self.view.frame.size.width/6, self.view.frame.size.width/6);
    
    _play.frame = CGRectMake(self.view.frame.size.width/2.15, self.view.frame.size.height/3, 150,75);
    
    _gameMode.frame = CGRectMake(self.view.frame.size.width/2.5, self.view.frame.size.height/6.2, 150,75);
    
    _sortMode.frame = CGRectMake(self.view.frame.size.width/2.5, self.view.frame.size.height/2 + self.view.frame.size.height/12, 150,75);

    
   
    
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
    [Sound playClick];
    /*
    UIButton *button = (UIButton *)sender;
    NSString *buttonTitle = button.currentTitle;
    SKView *skView = (SKView *)self.view;
    SKScene *scene = skView.scene;
     */
    //CALL SOME METHOD HERE PASSING ALONG THE NAME OF THE COMMAND TO THE SCENE
    //[scene sendCommand: buttonTitle]; or something equivalent
    
}

-(id) getHighest: (NSString*) first with: (NSString*) second and: (NSString*) third prefs: (NSUserDefaults*) prefs{
    if([prefs doubleForKey: first] > [prefs doubleForKey: second]){
        if([prefs doubleForKey: first] > [prefs doubleForKey: third]){
            return first;
        }else{
            return third;
        }
    }else{
        if([prefs doubleForKey: second] > [prefs doubleForKey: third]){
            return second;
        }else{
            return third;
        }
    }
}

- (IBAction)gamecenterButton:(id)sender {
    [self updateAllLeaderboards];
    [self showLeaderboardAndAchievements:YES];
}

-(void) updateAllLeaderboards{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //Deck Game Mode
    if([prefs doubleForKey: (NSString*)[self getHighest: @"HS01" with: @"HS11" and: @"HS21" prefs: prefs]] != 0){
        NSLog(@"setting red black leaderboard");
        [self setLeaderboard: @"redblackleaderboard" withScore: ([prefs doubleForKey: [self getHighest: @"HS01" with: @"HS11" and: @"HS21" prefs:prefs]] * 100)];
    }
    if([prefs doubleForKey: [NSString stringWithFormat:@"HS31"]] != 0 ){
        NSLog(@"setting setting shuffle leaderboard");
        [self setLeaderboard: @"shuffleleaderboard" withScore: ([prefs doubleForKey: [NSString stringWithFormat:@"HS31"]] * 100)];
    }
    
    //Marathon
    if([prefs doubleForKey: (NSString*)[self getHighest: @"HS02" with: @"HS12" and: @"HS22" prefs: prefs]] != 0){
        NSLog(@"setting marathon all leaderboard");
        [self setLeaderboard: @"marathonallleaderboard" withScore: ([prefs doubleForKey: [self getHighest: @"HS02" with: @"HS12" and: @"HS22" prefs:prefs]])];
    }
    if([prefs doubleForKey: [NSString stringWithFormat:@"HS32"]] != 0 ){
        NSLog(@"setting setting marathon shuffle leaderboard");
        [self setLeaderboard: @"marathonshuffleleaderboard" withScore: ([prefs doubleForKey: [NSString stringWithFormat:@"HS32"]])];
    }
    
    //Sprint
    if([prefs doubleForKey: (NSString*)[self getHighest: @"HS00" with: @"HS10" and: @"HS20" prefs: prefs]] != 0){
        NSLog(@"setting sprint all leaderboard");
        [self setLeaderboard: @"sprintallleaderboard" withScore: ([prefs doubleForKey: [self getHighest: @"HS00" with: @"HS10" and: @"HS20" prefs:prefs]])];
    }
    if([prefs doubleForKey: [NSString stringWithFormat:@"HS30"]] != 0 ){
        NSLog(@"setting sprint shuffle leaderboard");
        [self setLeaderboard: @"sprintshuffleleaderboard" withScore: ([prefs doubleForKey: [NSString stringWithFormat:@"HS30"]])];
    }
    
    //Accuracy
    int totalCardsSwiped = (int)[prefs integerForKey: @"totalCardsSwiped"];
    int totalSwipedCorrectly = (int)[prefs integerForKey: @"totalSwipedCorrectly"];
    if(totalCardsSwiped > 100){
        double percentage = ((((double) totalSwipedCorrectly / (double) totalCardsSwiped)));
        NSLog(@"setting accuracy to %f", percentage);
        [self setLeaderboard: @"accuracyleaderboard" withScore: percentage * 100];
    }
}

- (IBAction)backgroundPressed:(id)sender {
    NSLog(@"BACKGROUND PRESSED");
    [self.transparentView removeFromSuperview];
    [self.instructionsView removeFromSuperview];
    self.instructionsView.hidden = true;
    self.transparentView.hidden = true;
}


- (IBAction)audioButtonPressed:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs integerForKey:@"audioOn"] == 2){
        [sender setBackgroundImage:[UIImage imageNamed: @"audiooff"] forState:UIControlStateNormal];
        [prefs setInteger: 1 forKey:@"audioOn"];
        [Sound playClick];
    }else{
        [sender setBackgroundImage:[UIImage imageNamed: @"audioon"] forState:UIControlStateNormal];
        [prefs setInteger: 2 forKey:@"audioOn"];
    }
    
}
- (IBAction)buttonPrssed:(id)sender {
    //Im currently using the sendCommandToGameScene method to play the sound
    //[Sound playClick];
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
    /*
    if ([self isViewLoaded] && self.view.window == nil) {
        NSLog(@"UNLOADING");
        self.view = nil;
        [self dismissViewControllerAnimated:NO completion:nil];
    }
     */
    // Release any cached data, images, etc that aren't in use.
}

/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}
 */

-(void) viewDidAppear:(BOOL)animated{
    [Sound playClick];
    [scene updateCardFront];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
