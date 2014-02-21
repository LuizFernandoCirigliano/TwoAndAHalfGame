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
#import "AmazeGameLayer.h"
#import "CC3UIViewController.h"
#import "AmazeGameScene.h"

@interface Game : NSObject

+(Game *)myGame;
-(Player *)topScorer;

- (void) configureGame;
- (void) startMinigame: (NSArray*) players;

- (void) jankenWithWinner: (NSInteger)winner andLooser: (NSInteger)looser;
- (void) jankenTie;



@property (strong, nonatomic) Janken *janken;
@property (strong, nonatomic) NSMutableArray *playerArray;

@property (strong, nonatomic) AmazeGameLayer *hudLayer;
@property (nonatomic, assign) int roundDuration;

@property (nonatomic, assign) int introDuration;

@property (nonatomic, strong) CC3ControllableLayer *mazeScene;

@end
