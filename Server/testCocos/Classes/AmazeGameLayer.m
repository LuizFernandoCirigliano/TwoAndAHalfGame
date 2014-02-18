/**
 *  AmazeGameLayer.m
 *  AmazeGame
 *
 *  Created by Luiz Fernando 2 on 1/20/14.
 *  Copyright Luiz Fernando 2 2014. All rights reserved.
 */

#import "AmazeGameLayer.h"

#import "CC3Light.h"

#import "Game.h"




@implementation AmazeGameLayer 

NSMutableArray *_scoreLabelArray;

CCLabelTTF *_middleLabel;
CCLabelTTF *_roundTimerLabel;

NSTimer *_roundTimer;

Game *_game;

-(void) dealloc {
    [super dealloc];
}



/**
 * Override to set up your 2D controls and other initial state, and to initialize update processing.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) initializeControls {
	[self scheduleUpdate];
}

-(void) updateHUD {
    for (int i = 0 ; i < [[[Game myGame] playerArray] count]; i ++)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            Player *player = [[Game myGame].playerArray objectAtIndex: i];
            
            NSString *score = [NSString stringWithFormat:@"Player %d: %d", i + 1, player.playerScore];
            
            [[_scoreLabelArray objectAtIndex:i] setString:score];

            // Create your Labels or other Cocos2D objects that use Labels or UIKit here…
        });
    }
}

-(void) displayWinnerMessageWithNumber: (NSInteger) winnerNumber
{
    CCLabelTTF *winLabel;
    
    winLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Player %d won!", winnerNumber + 1] fontName:@"Arial" fontSize:60];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    winLabel.position = ccp(winSize.width/2, winSize.height/2);
    ccColor3B color = {255, 215, 0};
    winLabel.color = color;
    //aaaaaaaaaabaabbab
    
    [self addChild:winLabel];
}

-(void) displayMiddleLabelWithString: (NSString *) messageString {
//#Error FIX LABELZ
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _middleLabel.string = messageString ;
    
        [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideMiddleLabel)  userInfo:nil repeats:NO];
    
     });
}

-(void) hideMiddleLabel {
    _middleLabel.string = @"";
}

#pragma mark Updating layer

/**
 * Override to perform set-up activity prior to the scene being opened
 * on the view, such as adding gesture recognizers.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) onOpenCC3Layer {
    NSLog(@"open la") ;


    glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _scoreLabelArray = [[NSMutableArray alloc] init];
    _game = [Game myGame];
    
    const float xoffset = 0.12;
    const float yoffset = 0.05;
    
    for (int i = 0; i < [[[Game myGame]playerArray] count] ; i++) {
        CCLabelTTF * _statusLabel;
        
        _statusLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Player %d: %d", i + 1, 0] fontName:@"Arial" fontSize:46];
        
        switch (i) {
                
            case 0:
                _statusLabel.position = ccp(winSize.width*xoffset, winSize.height * (1- yoffset));
                break;
            case 1:
                 _statusLabel.position = ccp(winSize.width*(1- xoffset), winSize.height * (yoffset));
                break;
            case 2:
                _statusLabel.position = ccp(winSize.width*(xoffset), winSize.height * (yoffset));
                break;
            case 3:
                _statusLabel.position = ccp(winSize.width*(1- xoffset), winSize.height * (1 - yoffset));
                break;
            default:
                break;
        }
        
        ccColor3B color = {255, 215, 0};
        _statusLabel.color = color;
        
        [self addChild:_statusLabel];
        [_scoreLabelArray addObject:_statusLabel];
    }
    
    
    _roundTimerLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%02d:%02d", _game.roundDuration/60, _game.roundDuration%60] fontName:@"Arial" fontSize:46];
    _roundTimerLabel.position = ccp(winSize.width/2, winSize.height*(1-yoffset));
    [self addChild:_roundTimerLabel];

    
    _roundTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    
    _middleLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:60];
    ccColor3B color = {255, 215, 0};
    _middleLabel.color = color;
    _middleLabel.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:_middleLabel];
}


-(void) updateTimer: (NSTimer *) timer {
    NSLog(@"%@", [timer description]);
    _roundTimerLabel.string = [NSString stringWithFormat:@"%02d:%02d", _game.roundDuration/60, _game.roundDuration%60];
    
    if (_game.roundDuration > 0)
        _game.roundDuration--;

}
/**
 * Override to perform tear-down activity prior to the scene disappearing.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) onCloseCC3Layer {
    [_roundTimer invalidate];
}


@end
