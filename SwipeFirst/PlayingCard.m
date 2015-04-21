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

int CARD_WIDTH = 1000 * 3/4;
int CARD_HEIGHT = 1400 * 3/4;

-(id) initWithName: (NSString*) me{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs integerForKey: @"selectedDeck"] != 0){
        self.selectedDeck = (int)[prefs integerForKey: @"selectedDeck"];
    }else{
        self.selectedDeck = 1;
    }
    
    self = [super initWithImageNamed: [NSString stringWithFormat:@"%dCardBack", self.selectedDeck]];
    //self.texture = [SKTexture textureWithImageNamed: @"CardBack"];
    
    CGSize size = CGSizeMake(CARD_WIDTH, CARD_HEIGHT);
    self.size = size;
    self.name = [NSString stringWithFormat:@"%d%@", self.selectedDeck, me];
    [self setFrontFacing: false];
    self.isMatched = false;
    
    //This should zoom the card images without the blur
    self.texture.filteringMode = SKTextureFilteringNearest;
    
    return self;
}

-(void) setPixelTexture{
    NSLog(@"set pixel texture!");
    self.texture.filteringMode = SKTextureFilteringNearest;
}

-(void) update{
    if(self.isFrontFancing){
        self.texture = [SKTexture textureWithImageNamed:self.name];
    } else {
        self.texture = [SKTexture textureWithImageNamed: [NSString stringWithFormat:@"%dCardBack", self.selectedDeck]];
    }
}

-(void) flip{
    if (self.isFrontFancing == YES) {
        self.texture = [SKTexture textureWithImageNamed: [NSString stringWithFormat:@"%dCardBack", self.selectedDeck]];
        [self setFrontFacing:NO];
    } else {
        NSLog(@"name: %@", self.name);
        self.texture.filteringMode = SKTextureFilteringNearest;
        self.texture = [SKTexture textureWithImageNamed: self.name];
        [self setFrontFacing:YES];
    }
}

-(BOOL) isEven{
    NSString *name = [self.name substringFromIndex:1];
    int number = [[name substringFromIndex:1] intValue];
    if(number % 2 == 1)
        return false;
    NSString *cardName = [name substringFromIndex:1];
    if(self.isFace){
        if([cardName isEqual: @"Q"]){
            return true;
        }
        return false;
    }
    return true;
}

-(BOOL) isRed{
    NSString *name = [self.name substringFromIndex:1];
    NSString *suit = [name substringToIndex:1];
    if([suit isEqualToString:@"H"] || [suit isEqualToString:@"D"])
        return true;
    return false;
}

-(BOOL) isFace{
    NSString *name = [self.name substringFromIndex:1];
    int number = [[name substringFromIndex:1] intValue];
    if(number >= 2 && number <= 10)
            return false;
    return true;
}


@end
