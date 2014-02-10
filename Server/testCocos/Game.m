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

- (void) configureGame
{
    self.janken = [[Janken alloc] init];
    self.playerArray = [[NSMutableArray alloc] init];
    self.roundDuration = 30;
}

/**
 * Sets players in minigame mode and starts a minigame
 \param players NSArray of Player containing players who shall play a minigame
 */
- (void) startMinigame: (NSArray*) players
{
    Player *a = [players firstObject];
    Player *b = [players lastObject];
    
    [_hudLayer displayMiddleLabelWithString:[NSString stringWithFormat:@"Player %d vs Player %d \r (look to your devices)!", a.index+1, b.index+1]];

    //One player is already playing a minigame case not handled! #FIXME
    for (Player *player in players)
    {
        NSData *data = [[[StartMinigameMessage alloc] init] archiveData];
        MCPeerID *peer =  [[[Connection myConnection] peerArray] objectAtIndex:player.index];
        [[Connection myConnection] sendData: data toPeer: peer];
        player.isPlayingMinigame = YES;
        [player.node stopAllActions];
    }
}


-(void) jankenWithWinner:(NSInteger)winner andLooser:(NSInteger)looser {

    Player *winnerPlayer = [self.playerArray objectAtIndex:winner];
    Player *looserPlayer = [self.playerArray objectAtIndex:looser];
    
    winnerPlayer.playerScore += 40;
    looserPlayer.playerScore -= 40;
    
    winnerPlayer.isPlayingMinigame = NO;
    looserPlayer.isPlayingMinigame = NO;
    
    self.janken = [[Janken alloc] init];

    [_hudLayer displayMiddleLabelWithString:[NSString stringWithFormat:@"Player %d beat Player %d!", winner+1, looser+1]];
}

- (void) jankenTie
{
    NSData *data = [[[StartMinigameMessage alloc] init] archiveData];
   
    MCPeerID *peer =  [[[Connection myConnection] peerArray] objectAtIndex:self.janken.playerAID];
    [[Connection myConnection] sendData: data toPeer: peer];
    
    peer =  [[[Connection myConnection] peerArray] objectAtIndex:self.janken.playerBID];
    [[Connection myConnection] sendData: data toPeer: peer];
    
    
    self.janken = [[Janken alloc] init];
}

-(Player *) topScorer {
    Player *topScoringPlayer = [self.playerArray firstObject];
 
    for (Player *player in self.playerArray) {
        if (player.playerScore > topScoringPlayer.playerScore)
            topScoringPlayer = player;
    }
    
    return topScoringPlayer;
}

@end
