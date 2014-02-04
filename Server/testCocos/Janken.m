//
//  Janken.m
//  TwoAndAHalfGame
//
//  Created by Francesco Perrotti-Garcia on 2/4/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "Janken.h"

@implementation Janken

#warning Add documentation
/**
 * Sets the gesture chosen by a given player
 \param playerID The ID of the player
 \param playerGesture The gesture chosen by the player
 */
- (void) player: (NSInteger) playerID chose: (JankenType) playerGesture
{
    if (!self.playerAGesture)
    {
        self.playerAID = playerID;
        self.playerAGesture = playerGesture;
    }
    else
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
            }
            break;
        }
    }
}

/**
 * Sets the winner
 \param winner The ID of the winning player
 */
- (void) setWinner:(NSInteger)winner
{
    _winner = winner;
    if (winner == kJankenTie)
    {
        //TIE ==> REMATCH
    }
    else
    {
        //WE HAVE A WINNER
    }
    self = [[Janken alloc] init];
}
@end
