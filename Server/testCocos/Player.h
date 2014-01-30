//
//  Player.h
//  TwoAndAHalfGame
//
//  Created by Francesco Perrotti-Garcia on 1/28/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "CC3Node.h"

@interface Player : NSObject

/**
 * Player index in the characters array
 */
@property (nonatomic) NSInteger index;

/**
 * Player location before movement
 */
@property (nonatomic) CC3Vector oldLocation;

/**
 * Player rotation angle before movement
 */
@property (nonatomic) GLfloat oldRotationAngle;

/**
 * Player node
 */
@property (nonatomic, strong) CC3Node *node;

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

- (id) initWithIndex: (NSInteger) index;
@end