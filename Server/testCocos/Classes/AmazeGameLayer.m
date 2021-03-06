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
#import "CCDirector.h"

@implementation AmazeGameLayer 

NSMutableArray *_scoreLabelArray;

CCLabelTTF *_middleLabel;
CCLabelTTF *_roundTimerLabel;

NSTimer *_roundTimer;

Game *_game;

bool _firstOpen;

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
    
    _firstOpen = YES;
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
    dispatch_async(dispatch_get_main_queue(), ^ {
        _middleLabel.string = [NSString stringWithFormat:@"Player %d won!", winnerNumber + 1] ;
    });
}

-(void) displayMiddleLabelWithString: (NSString *) messageString {
    
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
    
    if (_firstOpen) {
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
        
        _firstOpen = NO;
    
        [NSTimer scheduledTimerWithTimeInterval:_game.introDuration target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
        
        _middleLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:60];
        ccColor3B color = {255, 215, 0};
        _middleLabel.color = color;
        _middleLabel.position = ccp(winSize.width/2, winSize.height/2);
        
        [self addChild:_middleLabel];
    }
}

-(void) startTimer {
    [[self scheduler] scheduleSelector:@selector(updateTimer) forTarget:self interval:1.0f paused:NO];
}

-(void) updateTimer{
    NSLog (@"timer update");
    if (![CCDirector.sharedDirector isPaused]) {
        [self updateHUD];
        
        _roundTimerLabel.string = [NSString stringWithFormat:@"%02d:%02d", _game.roundDuration/60, _game.roundDuration%60];
        
        if (_game.roundDuration > 0)
            _game.roundDuration--;
        else if([_roundTimer isValid])
            [_roundTimer invalidate];
    }

}
/**
 * Override to perform tear-down activity prior to the scene disappearing.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) onCloseCC3Layer {

}


@end
