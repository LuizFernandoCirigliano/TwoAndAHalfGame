//
//  Game.m
//  TwoAndAHalfGame
//
//  Created by Luiz Fernando 2 on 2/4/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "Game.h"

@implementation Game

static Game *myGameConfiguration = nil;

+ (Game *) myGame
{
    
    if (!myGameConfiguration)
    {
        myGameConfiguration = [[super allocWithZone:nil] init];
    }
    
    return myGameConfiguration;
}

- (void) configureGame {
    
    self.janken = [[Janken alloc] init];
    self.playerArray = [[NSMutableArray alloc] init];
}


@end
