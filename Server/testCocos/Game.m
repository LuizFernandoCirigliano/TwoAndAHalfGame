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

/**
 * Sets players in minigame mode and starts a minigame
 \param players NSArray of Player containing players who shall play a minigame
 */
- (void) startMinigame: (NSArray*) players
{
    //One player is already playing a minigame case not handled! #FIXME
    for (Player *player in players)
    {
        MCPeerID *peer =  [[[Connection myConnection] peerArray] objectAtIndex:player.index];
        NSData *data = [[[StartMinigameMessage alloc] init] archiveData];
        [[Connection myConnection] sendData: data toPeer: peer];
        player.isPlayingMinigame = YES;
        [player.node stopAllActions];
    }
}

-(void) jankenWithWinner:(NSInteger)winner andLooser:(NSInteger)looser {
    Player *winnerPlayer = [self.playerArray objectAtIndex:winner];
    Player *looserPlayer = [self.playerArray objectAtIndex:looser];
    winnerPlayer.playerScore += 10;
    looserPlayer.playerScore -= 10;
}

@end
