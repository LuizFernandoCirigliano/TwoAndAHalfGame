//
//  Janken.m
//  TwoAndAHalfGame
//
//  Created by Francesco Perrotti-Garcia on 2/4/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#define kJankenError -666

#import "Janken.h"
#import "Game.h"

@interface Janken ()

/**
 * The ID of player number A
 */
@property (nonatomic) NSInteger playerAID;

/**
 * The ID of player number B
 */
@property (nonatomic) NSInteger playerBID;

/**
 * The gesture of player number A
 */
@property (nonatomic) JankenType playerAGesture;

/**
 * The gesture of player number A
 */
@property (nonatomic) JankenType playerBGesture;

@end
@implementation Janken

//w Add documentation
/**
 * Sets the gesture chosen by a given player
 \param playerID The ID of the player
 \param playerGesture The gesture chosen by the player
 */
-(id) init {
    self = [super init];
    
    if (self) {
        self.playerAGesture = nothing;
    }
    
    return self;
}
- (void) player: (NSInteger) playerID chose: (JankenType) playerGesture
{
//    NSLog(@"ID -> %d, Gesture -> %d", playerID, playerGesture);
    if (self.playerAGesture == nothing)
    {
        self.playerAID = playerID;
        self.playerAGesture = playerGesture;
    }
    else if (playerID != self.playerAID)
    {
        self.playerBID = playerID;
        self.playerBGesture = playerGesture;
        self.winner = [self winningPlayer];
    }
}


/**
 * Returns the ID of the winning player or kJankenTie in case of a tie
 */
- (NSInteger) winningPlayer
{
    switch (self.playerAGesture)
    {
        case Rock:
        {
            switch (self.playerBGesture)
            {
                case Rock:
                    return kJankenTie;
                case Paper:
                    return self.playerBID;
                case Scissors:
                    return self.playerAID;
                case TLE:
                    return self.playerAID;
                case nothing:
                    return kJankenError;
            }
            break;
        }
        case Paper:
        {
            switch (self.playerBGesture)
            {
                case Rock:
                    return self.playerAID;
                case Paper:
                    return kJankenTie;
                case Scissors:
                    return self.playerBID;
                case TLE:
                    return self.playerAID;
                case nothing:
                    return kJankenError;
            }
            break;
        }
        case Scissors:
        {
            switch (self.playerBGesture)
            {
                case Rock:
                    return self.playerBID;
                case Paper:
                    return self.playerAID;
                case Scissors:
                    return kJankenTie;
                case TLE:
                    return self.playerAID;
                case nothing:
                    return kJankenError;
            }
            break;
        }
        case TLE:
        {
            if (self.playerBGesture == TLE)
            {
                return kJankenTie;
            }
            else if (self.playerBGesture == nothing)
            {
                return kJankenError;
            }
            else
            {
                return self.playerBID;
            }
        }
        case nothing:
        {
            return kJankenError;
        }
    }
}

/**
 * Sets the winner
 \param winner The ID of the winning player
 */
- (void) setWinner:(NSInteger)winner
{
    Game *game = [Game myGame];
    _winner = winner;
    if (winner == kJankenTie)
    {
        //TIE ==> REMATCH
        NSDate *now = [NSDate date];
        Player *playerA = [[Game myGame].playerArray objectAtIndex:self.playerAID];
        Player *playerB = [[Game myGame].playerArray objectAtIndex:self.playerBID];
        [playerA.lastPlayerCollisionTimestamp setObject:now forKey:[NSString stringWithFormat:@"%d", self.playerBID]];
        [playerB.lastPlayerCollisionTimestamp setObject:now forKey:[NSString stringWithFormat:@"%d", self.playerAID]];
        [game jankenTie];
    }
    else
    {
        //WE HAVE A WINNER
        NSInteger looser = (winner == self.playerAID) ? self.playerBID : self.playerAID;
        [game jankenWithWinner: winner andLooser: looser];
    }
}
@end
