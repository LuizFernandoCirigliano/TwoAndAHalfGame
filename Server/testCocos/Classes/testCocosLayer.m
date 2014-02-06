/**
 *  testCocosLayer.m
 *  testCocos
 *
 *  Created by Luiz Fernando 2 on 1/20/14.
 *  Copyright Luiz Fernando 2 2014. All rights reserved.
 */

#import "testCocosLayer.h"

#import "CC3Light.h"

#import "Game.h"



@implementation testCocosLayer 

NSMutableArray *_scoreLabelArray;

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
    
    self.isTouchEnabled = YES;
    
}

-(void) updateHUD {
    for (int i = 0 ; i < [[[Game myGame] playerArray] count]; i ++)
    {
        Player *player = [[Game myGame].playerArray objectAtIndex: i];
        NSString *score = [NSString stringWithFormat:@"Player %d : %d", i + 1, player.playerScore];
        
        [[_scoreLabelArray objectAtIndex:i] setString:score];
    }
}

-(void) updateHUDPosition {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    for (int i = 0; i < [_scoreLabelArray count] ; i++) {
        
        CCLabelTTF * _statusLabel = [_scoreLabelArray objectAtIndex: i];
        
        const float xoffset = 0.12;
        const float yoffset = 0.05;
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
    }
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


    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _scoreLabelArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [[[Game myGame]playerArray] count] ; i++) {
        CCLabelTTF * _statusLabel;
        
        _statusLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Player %d: %d", i + 1, 0] fontName:@"Arial" fontSize:46];
        const float xoffset = 0.12;
        const float yoffset = 0.05;
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
}



/**
 * Override to perform tear-down activity prior to the scene disappearing.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) onCloseCC3Layer {}

/**
 * The ccTouchMoved:withEvent: method is optional for the <CCTouchDelegateProtocol>.
 * The event dispatcher will not dispatch events for which there is no method
 * implementation. Since the touch-move events are both voluminous and seldom used,
 * the implementation of ccTouchMoved:withEvent: has been left out of the default
 * CC3Layer implementation. To receive and handle touch-move events for object
 * picking, uncomment the following method implementation.
 */

//-(void) ccTouchMoved: (UITouch *)touch withEvent: (UIEvent *)event {
//	[self handleTouch: touch ofType: kCCTouchMoved];
//}

@end
