//
//  Player.m
//  TwoAndAHalfGame
//
//  Created by Francesco Perrotti-Garcia on 1/28/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "Player.h"
#import "Game.h"
#import "CC3Billboard.h"


@implementation Player

CC3Billboard *_thiefMarker;

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
        _state = NORMAL;
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
        _state = NORMAL;

    }
    return self;
}

-(void) returnToNormalState{
    _state = NORMAL;
    
    self.node.emissionColor = CCC4FMake(0.0, 0.0, 0.0, 0.0);
}

-(void) setPlayerScore:(NSInteger)playerScore {
    _playerScore = playerScore;
    [[[Game myGame] hudLayer] updateHUD];
}

-(void) setState:(NSInteger)state {
    _state = state;
    if (state == NORMAL) {
        self.node.emissionColor = CCC4FMake(0.0, 0.0, 0.0, 0.0);
    } else if (state == THIEF) {
        dispatch_async( dispatch_get_main_queue(), ^{
            
            [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(returnToNormalState) userInfo:nil repeats:NO];
            
            self.node.emissionColor = CCC4FMake(1.0, 0, 0, 1.0);
            
        });
    } else if (state == FREEZER) {
        dispatch_async( dispatch_get_main_queue(), ^{
            
            [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(returnToNormalState) userInfo:nil repeats:NO];
            
            self.node.emissionColor = CCC4FMake(0.0, 0, 0.5, 1.0);
            
        });
    } else if (state == SPRINT) {
        dispatch_async( dispatch_get_main_queue(), ^{
            
            [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(returnToNormalState) userInfo:nil repeats:NO];
            
            self.node.emissionColor = CCC4FMake(0.0, 1.0, 0.0, 1.0);
            
        });
    } else if (state == FROZEN) {
        dispatch_async( dispatch_get_main_queue(), ^{
            
            [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(returnToNormalState) userInfo:nil repeats:NO];
            
            self.node.emissionColor = CCC4FMake(0.0, 0, 0.5, 1.0);
            
        });
    }
}
@end
