//
//  Player.m
//  TwoAndAHalfGame
//
//  Created by Francesco Perrotti-Garcia on 1/28/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "Player.h"

@implementation Player

- (NSMutableDictionary*) lastPlayerCollisionTimestamp
{
    //Lazy instantiation
    if (!_lastPlayerCollisionTimestamp)
    {
    //Allocates and inititializes a mutable dictionary with last player collision timestamps
    //Set as default to unix time 0
    self.lastPlayerCollisionTimestamp = [NSMutableDictionary dictionaryWithDictionary:
       @{@"0" : [NSDate dateWithTimeIntervalSince1970:0.0f],
         @"1" : [NSDate dateWithTimeIntervalSince1970:0.0f],
         @"2" : [NSDate dateWithTimeIntervalSince1970:0.0f],
         @"3" : [NSDate dateWithTimeIntervalSince1970:0.0f]}];
    }
    return _lastPlayerCollisionTimestamp;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        self.isPlayingMinigame = NO;
    }
    return self;
}

/**
 * Initializes a player with a given index
 \param index Player index in the characters array
 \returns An initilaized player with index already set
 */
- (id) initWithIndex: (NSInteger) index
{
    self = [self init];
    if (self)
    {
        self.index = index;
        self.isPlayingMinigame = NO;
    }
    return self;
}

-(void) setPlayerScore:(NSInteger)playerScore {
    _playerScore = playerScore;
    [[[Game myGame] hudLayer] updateHUD];
    NSLog (@"%@", [[Game myGame] hudLayer] );
}
@end
