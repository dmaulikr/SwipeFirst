//
//  PlayingCard.h
//  CardGame
//
//  Created by Ian Johnson on 2/25/15.
//  Copyright (c) 2015 Ian Johnson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>

@interface PlayingCard : SKSpriteNode

-(id) initWithName: (NSString*) me;
-(void) flip;
-(void) update;
-(BOOL) isEven;
-(BOOL) isRed;

@property NSString* name;
@property (setter=setFrontFacing:) bool isFrontFancing;
@property bool isMatched;


@end
