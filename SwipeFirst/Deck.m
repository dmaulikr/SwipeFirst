//
//  Deck.m
//  CardGame
//
//  Created by Ian Johnson on 2/25/15.
//  Copyright (c) 2015 Ian Johnson. All rights reserved.
//

#import "Deck.h"
#import "PlayingCard.h"

@implementation Deck

-(id) init{
    _numTaken = 0;
    //NSLog(@"Initializing");
    self.arrayOfCards = [[NSMutableArray alloc] init];
    NSArray* number = [NSArray arrayWithObjects:@"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K", nil];
    NSArray* suits = [NSArray arrayWithObjects:@"C", @"D", @"H", @"S", nil];
    
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 2; j++) {
            NSString *num = [number objectAtIndex:j];
            NSString *suit = [suits objectAtIndex:i];
            NSString *cardName = [NSString stringWithFormat:@"%@%@", suit, num];
            PlayingCard *card;
            card = [[PlayingCard alloc] initWithName: (NSString*) cardName];
            [self.arrayOfCards addObject:card];
        }
    }
    
    //NSLog(@"%@", self.arrayOfCards);
    
    return self;
}

-(PlayingCard*) getRandomCard: (bool) remove{
    //NSLog(@"%d", (int)[self.arrayOfCards count]);
    int loc = arc4random() % [self.arrayOfCards count];
    PlayingCard* cardName = ((PlayingCard*)[self.arrayOfCards objectAtIndex: loc]);
    if(remove){
        [self.arrayOfCards removeObjectAtIndex:loc];
    }
    _numTaken++;
    //NSLog(@"Card name in getRandomCard %@", cardName.name);
    return cardName;
}


@end
