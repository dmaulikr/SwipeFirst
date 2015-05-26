//
//  UnlockablesViewController.m
//  SwipeFirst
//
//  Created by Jared Weinstein on 4/1/15.
//  Copyright (c) 2015 CCHS. All rights reserved.
//

#import "UnlockablesViewController.h"

@interface UnlockablesViewController ()

@end

@implementation UnlockablesViewController

int selectedDeck;

- (IBAction)backButtonPressed:(id)sender {
    [Sound playClick];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //[self.deck5 setEnabled:false];
    //[self.deck4 setEnabled:false];
    //[self.deck3 setEnabled:false];
    //[self.deck2 setEnabled:false];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs integerForKey: @"selectedDeck"] != 0){
        selectedDeck = (int)[prefs integerForKey:@"selectedDeck"];
        [self updateImages];
    }
    
    if([prefs boolForKey:@"deck2unlocked"] == true){
        
        
    }else{
        NSLog(@"Set Disabled");
        [self.deck2 setEnabled:false];
        [self.deck2 setBackgroundImage: [UIImage imageNamed: @"QuestionMarkCard.png"] forState: UIControlStateNormal];
    }
    if([prefs boolForKey:@"deck3unlocked"] == true){
        
    }else{
        NSLog(@"Set Disabled");
        [self.deck3 setEnabled:false];
        [self.deck3 setBackgroundImage: [UIImage imageNamed: @"QuestionMarkCard.png"] forState: UIControlStateNormal];
    }
    if([prefs boolForKey:@"deck4unlocked"] == true){
        
    }else{
        NSLog(@"Set Disabled");
        [self.deck4 setEnabled:false];
        [self.deck4 setBackgroundImage: [UIImage imageNamed: @"QuestionMarkCard.png"] forState: UIControlStateNormal];
    }
    
    
    //This process is really really slow. Like noticable delay on screen
    //Also the deck wont be unlocked if there isn't wifi. We should probably store this data locally
    [GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error)
    {
        if(error != NULL) {
            /* error handling GameCenter doesn't load need to load in the defaults */
        }
        for (GKAchievement* achievement in scores) {
            if([achievement.identifier  isEqual: @"deck2unlocked"]){
                NSLog(@"%d%@", [achievement isCompleted], achievement.identifier);
                if([achievement isCompleted] == true && [prefs boolForKey:@"deck2unlocked"] == false){
                    [self.deck2 setEnabled:true];
                    [self.deck2 setBackgroundImage: [UIImage imageNamed: @"2CardBack.png"] forState: UIControlStateNormal];
                    [prefs setBool:true forKey:@"deck2unlocked"];
                }
            }
            if([achievement.identifier  isEqual: @"deck3unlocked"]){
                NSLog(@"%d%@", [achievement isCompleted], achievement.identifier);
                if([achievement isCompleted] == true && [prefs boolForKey:@"deck3unlocked"] == false){
                    [self.deck3 setEnabled:true];
                    [self.deck3 setBackgroundImage: [UIImage imageNamed: @"3CardBack.png"] forState: UIControlStateNormal];
                    [prefs setBool:true forKey:@"deck3unlocked"];

                }
            }
            if([achievement.identifier  isEqual: @"deck4unlocked"]){
                NSLog(@"%d%@", [achievement isCompleted], achievement.identifier);
                if([achievement isCompleted] == true && [prefs boolForKey:@"deck4unlocked"] == false){
                    [self.deck4 setEnabled:true];
                    [self.deck4 setBackgroundImage: [UIImage imageNamed: @"4CardBack.png"] forState: UIControlStateNormal];
                    [prefs setBool:true forKey:@"deck4unlocked"];

                }
            }
             
            /*
            if([achievement.identifier  isEqual: @"deck5unlocked"]){
                NSLog(@"%d%@", [achievement isCompleted], achievement.identifier);
                if([achievement isCompleted] == true){
                    [self.deck5 setEnabled:true];
                }
            }
             */
        }
        [self updateImages];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deck1Selected:(id)sender {
    [self selectValue: 1];
}

- (IBAction)deck2Selected:(id)sender {
    [self selectValue: 2];
}

- (IBAction)deck3Selected:(id)sender {
    [self selectValue: 3];
}

- (IBAction)deck4Selected:(id)sender {
    [self selectValue: 4];
}

- (IBAction)deck5Selected:(id)sender {
    [self selectValue: 5];
}

-(void) selectValue: (int) val{
    [Sound playClick];
    if(selectedDeck != val){
        selectedDeck = val;
        [self updateImages];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:val forKey: @"selectedDeck"];
    }
}

-(void) updateImages{
    if(self.deck1.isEnabled){
        [self.deck1 setBackgroundImage:[UIImage imageNamed: @"1CardBack.png"] forState: UIControlStateNormal];
    }else{
        [self.deck1 setBackgroundImage:[UIImage imageNamed: @"QuestionMarkCard.png"] forState: UIControlStateNormal];
    }
    if(self.deck2.isEnabled){
        [self.deck2 setBackgroundImage:[UIImage imageNamed: @"2CardBack.png"] forState: UIControlStateNormal];
    }else{
        [self.deck2 setBackgroundImage:[UIImage imageNamed: @"QuestionMarkCard.png"] forState: UIControlStateNormal];
    }
    if(self.deck3.isEnabled){
        [self.deck3 setBackgroundImage:[UIImage imageNamed: @"3CardBack.png"] forState: UIControlStateNormal];
    }else{
        [self.deck3 setBackgroundImage:[UIImage imageNamed: @"QuestionMarkCard.png"] forState: UIControlStateNormal];
    }
    if(self.deck4.isEnabled){
        [self.deck4 setBackgroundImage:[UIImage imageNamed: @"4CardBack.png"] forState: UIControlStateNormal];
    }else{
        [self.deck4 setBackgroundImage:[UIImage imageNamed: @"QuestionMarkCard.png"] forState: UIControlStateNormal];
    }
    //[self.deck5 setBackgroundImage:[UIImage imageNamed: @"1CardBack.png"] forState: UIControlStateNormal];
    switch (selectedDeck) {
        case 1:
            [self.deck1 setBackgroundImage:[UIImage imageNamed: @"1CK.png"] forState: UIControlStateNormal];
            break;
        case 2:
            [self.deck2 setBackgroundImage:[UIImage imageNamed: @"2CK.png"] forState: UIControlStateNormal];
            break;
        case 3:
            [self.deck3 setBackgroundImage:[UIImage imageNamed: @"3CK.png"] forState: UIControlStateNormal];
            break;
        case 4:
            [self.deck4 setBackgroundImage:[UIImage imageNamed: @"4CK.png"] forState: UIControlStateNormal];
            break;
        /*
        case 5:
            [self.deck5 setBackgroundImage:[UIImage imageNamed: @"1CK.png"] forState: UIControlStateNormal];
            break;
        */
        default:
            [self.deck1 setBackgroundImage:[UIImage imageNamed: @"1CK.png"] forState: UIControlStateNormal];
            selectedDeck = 1;
            break;
            
        
            
    }}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
