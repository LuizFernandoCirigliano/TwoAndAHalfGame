//
//  Player.h
//  TwoAndAHalfGame
//
//  Created by Francesco Perrotti-Garcia on 1/28/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "CC3Node+Collision.h"
#import "Minigame.h"

@class Player;

@protocol PlayerSceneDelegate <NSObject>
@required
- (void) replaceNodeForPlayer: (Player *) player;
@end

@interface Player : NSObject

@property (nonatomic) NSInteger state;
/**
 * Player index in the characters array.
 */
@property (nonatomic) NSInteger index;

/**
 * Score of the player.
 */
@property (nonatomic) NSInteger playerScore;

/**
 * ID of the device (used by Multipeer connectivity).
 */
@property (strong, nonatomic) NSString *deviceID;

/**
 * Node location before movement.
 */
@property (nonatomic, assign) CC3Vector oldLocation;

/**
 * Player node.
 */
@property (nonatomic, strong) CC3Node *node;

@property (nonatomic, strong) CC3Node *originalNode;

/**
 * Dictionary containing the timestamp of the last time the player has collided with another player.
 * Set as default to unix time 0.
 */

@property (nonatomic, strong) NSMutableDictionary *lastPlayerCollisionTimestamp;

/**
 * A Boolean value indicating whether the receiver is playing a minigame.
 *
 * The default value for this property is NO.
 */
@property (nonatomic) BOOL isPlayingMinigame;

@property (nonatomic) Direction direction;

/**
 * Minigame currently being played by the player.
 *
 * nil if the player is not in a minigame.
 */
@property (nonatomic, strong) Minigame *minigame;


/**
 * Add property description here
 */
@property (nonatomic, assign) id delegate;



- (id) initWithIndex: (NSInteger) index;

typedef enum playerStateEnum {
    NORMAL,
    THIEF,
    FREEZER,
    FROZEN,
    SPRINT,
} playerState;

@end
