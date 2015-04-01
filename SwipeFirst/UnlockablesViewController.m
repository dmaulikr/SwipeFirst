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

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs integerForKey: @"selectedDeck"] != 0){
        selectedDeck = (int)[prefs integerForKey:@"selectedDeck"];
        [self updateImages];
    }
    
    //This can be simplified into one method if I wasn't so lazy
    GKAchievement *unlocked2 = [[GKAchievement alloc] initWithIdentifier: @"deck2unlocked"];
    if([unlocked2 isCompleted] == true){
        [self.deck2 setEnabled:true];
    }else{
        [self.deck2 setEnabled:false];
    }
    GKAchievement *unlocked3 = [[GKAchievement alloc] initWithIdentifier: @"deck3unlocked"];
    if([unlocked3 isCompleted] == true){
        [self.deck3 setEnabled:true];
    }else{
        [self.deck3 setEnabled:false];

    }
    GKAchievement *unlocked4 = [[GKAchievement alloc] initWithIdentifier: @"deck4unlocked"];
    if([unlocked4 isCompleted] == true){
        [self.deck4 setEnabled:true];
    }else{
        [self.deck4 setEnabled:false];
    }
    GKAchievement *unlocked5 = [[GKAchievement alloc] initWithIdentifier: @"deck5unlocked"];
    if([unlocked5 isCompleted] == true){
        [self.deck5 setEnabled:true];
    }else{
        [self.deck5 setEnabled:false];
    }
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
    if(selectedDeck != val){
        selectedDeck = val;
        [self updateImages];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:val forKey: @"selectedDeck"];
    }
}

-(void) updateImages{
    [self.deck1 setBackgroundImage:[UIImage imageNamed: @"CardBack.png"] forState: UIControlStateNormal];
    [self.deck2 setBackgroundImage:[UIImage imageNamed: @"CardBack.png"] forState: UIControlStateNormal];
    [self.deck3 setBackgroundImage:[UIImage imageNamed: @"CardBack.png"] forState: UIControlStateNormal];
    [self.deck4 setBackgroundImage:[UIImage imageNamed: @"CardBack.png"] forState: UIControlStateNormal];
    [self.deck5 setBackgroundImage:[UIImage imageNamed: @"CardBack.png"] forState: UIControlStateNormal];
    switch (selectedDeck) {
        case 1:
            [self.deck1 setBackgroundImage:[UIImage imageNamed: @"CK.png"] forState: UIControlStateNormal];
            break;
        case 2:
            [self.deck2 setBackgroundImage:[UIImage imageNamed: @"CK.png"] forState: UIControlStateNormal];
            break;
        case 3:
            [self.deck3 setBackgroundImage:[UIImage imageNamed: @"CK.png"] forState: UIControlStateNormal];
            break;
        case 4:
            [self.deck4 setBackgroundImage:[UIImage imageNamed: @"CK.png"] forState: UIControlStateNormal];
            break;
        case 5:
            [self.deck5 setBackgroundImage:[UIImage imageNamed: @"CK.png"] forState: UIControlStateNormal];
            break;
        default:
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
