//
//  Player.h
//  TwoAndAHalfGame
//
//  Created by Francesco Perrotti-Garcia on 1/28/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "CC3Node.h"

@interface Player : NSObject

@property (nonatomic) NSInteger index;
@property (nonatomic) CC3Vector oldLocation;
@property (nonatomic) GLfloat oldRotationAngle;
@property (nonatomic, strong) CC3Node *node;
@property (nonatomic, strong) NSMutableDictionary *lastPlayerCollisionTimestamp;

@end
