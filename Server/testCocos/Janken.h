//
//  Janken.h
//  TwoAndAHalfGame
//
//  Created by Francesco Perrotti-Garcia on 2/4/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "Minigame.h"

#define kJankenTie -1

typedef NS_ENUM(NSInteger, JankenType)
{
    Rock,
    Paper,
    Scissors,
    TLE,
    nothing
};


@interface Janken : Minigame

/**
 * The ID of the winning player
 */
@property (nonatomic) NSInteger winner;
/**
 * The ID of player number A
 */
@property (nonatomic) NSInteger playerAID;

/**
 * The ID of player number B
 */
@property (nonatomic) NSInteger playerBID;


- (void) player: (NSInteger) playerID chose: (JankenType) playerGesture;

@end
