//
//  PlayingCard.m
//  CardGame
//
//  Created by Ian Johnson on 2/25/15.
//  Copyright (c) 2015 Ian Johnson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PlayingCard.h"

@implementation PlayingCard

-(id) initWithName: (NSString*) me{
    self = [super initWithImageNamed: @"CardBack"];
    //self.texture = [SKTexture textureWithImageNamed: @"CardBack"];
    self.name = me;
    [self setFrontFacing: false];
    self.isMatched = false;
    return self;
}

-(void) update{
    if(self.isFrontFancing){
        self.texture = [SKTexture textureWithImageNamed:self.name];
    } else {
        self.texture = [SKTexture textureWithImageNamed: @"CardBack"];
    }
}

-(void) flip{
    if (self.isFrontFancing == YES) {
        self.texture = [SKTexture textureWithImageNamed: @"CardBack"];
        [self setFrontFacing:NO];
    } else {
        NSLog(@"name: %@", self.name);
        self.texture = [SKTexture textureWithImageNamed: self.name];
        [self setFrontFacing:YES];
    }
}

-(BOOL) isEven{
    int number = [[self.name substringFromIndex:1] intValue];
    if(number % 2 == 1)
        return false;
    return true;
}

-(BOOL) isRed{
    NSString *suit = [self.name substringToIndex:1];
    if([suit isEqualToString:@"H"] || [suit isEqualToString:@"D"])
        return true;
    return false;
}



@end
