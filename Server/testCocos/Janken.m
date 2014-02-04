//
//  Janken.m
//  TwoAndAHalfGame
//
//  Created by Francesco Perrotti-Garcia on 2/4/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "Janken.h"

#define kJankenTie -1

typedef NS_ENUM(NSInteger, JankenType)
{
    Rock,
    Paper,
    Scissors
};

@implementation Janken


/*
 * Return the ID of the winning player or kJankenTie in case of a tie
 \param playerAID The ID of the A player
 \param playerAGesture The gesture of the A player
 \param playerBID The ID of the B player
 \param playerBGesture The gesture of the B player
 */
- (NSInteger) winningPlayerWhenPlayer: (NSInteger) playerAID chose: (JankenType) playerAGesture andPlayer: (NSInteger) playerBID chose: (JankenType) playerBGesture
{
    switch (playerAGesture)
    {
        case Rock:
        {
            switch (playerBGesture)
            {
                case Rock:
                    return kJankenTie;
                case Paper:
                    return playerBID;
                case Scissors:
                    return playerAID;
            }
            break;
        }
        case Paper:
        {
            switch (playerBGesture)
            {
                case Rock:
                    return playerAID;
                case Paper:
                    return kJankenTie;
                case Scissors:
                    return playerBID;
            }
            break;
        }
        case Scissors:
        {
            switch (playerBGesture)
            {
                case Rock:
                    return playerBID;
                case Paper:
                    return playerAID;
                case Scissors:
                    return kJankenTie;
            }
            break;
        }
    }
}
@end
