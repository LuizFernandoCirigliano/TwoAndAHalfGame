//
//  Game.h
//  TwoAndAHalfGame
//
//  Created by Luiz Fernando 2 on 2/4/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Janken.h"
#import "Player.h"
#import "Connection.h"

@interface Game : NSObject

+(Game *)myGame;

- (void) configureGame;
- (void) startMinigame: (NSArray*) players;
- (void) jankenWithWinner: (NSInteger)winner;

@property (strong, nonatomic) Janken *janken;
@property (strong, nonatomic) NSMutableArray *playerArray;


@end
