//
//  CC3Node+Collision.h
//  AmazeGame
//
//  Created by Francesco Perrotti-Garcia on 1/24/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "CC3Node.h"

typedef NS_ENUM(NSInteger, Direction)
{
    Up,
    Right,
    Down,
    Left,
    Other
};

@interface CC3Node (Collision)

- (void) createBoundingVolumeFromBoundingBox;
- (void) createSphericalBoundingVolumeFromBoundingBox;
- (void) createSphericalBoundingVolumeFromBoundingBoxWithRadiusRatio: (float) ratio;
- (BOOL) shouldMove;
- (BOOL) shouldMove: (Direction) direction;


@end
