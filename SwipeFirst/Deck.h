//
//  Deck.h
//  CardGame
//
//  Created by Ian Johnson on 2/25/15.
//  Copyright (c) 2015 Ian Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingCard.h"

@interface Deck : NSObject

-(id) init;
-(PlayingCard*) getRandomCard: (bool) remove;
@property int numTaken;
@property NSMutableArray* arrayOfCards;


@end
