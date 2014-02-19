/**
 *  AmazeGameScene.h
 *  AmazeGame
 *
 *  Created by Luiz Fernando 2 on 1/20/14.
 *  Copyright Luiz Fernando 2 2014. All rights reserved.
 */


#import "CC3Scene.h"
#import "Connection.h"
#import "Player.h"
/** A sample application-specific CC3Scene subclass.*/

@protocol Cocos3DViewControllerDelegate <NSObject>

@required

- (void) dissmissVC;

@end

@interface AmazeGameScene : CC3Scene 

{
    
}

/**
 * Add property description here
 */
@property BOOL flip;

/**
 * Add property description here
 */
@property (strong, nonatomic) CC3Camera *cam;


@property (nonatomic, assign) id delegate;

@end
