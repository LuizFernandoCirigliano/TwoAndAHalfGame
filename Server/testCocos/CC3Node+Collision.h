//
//  CC3Node+Collision.h
//  testCocos
//
//  Created by Francesco Perrotti-Garcia on 1/24/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "CC3Node.h"

@interface CC3Node (Collision)

- (void) createBoundingVolumeFromBoundingBox;
- (void) createSphericalBoundingVolumeFromBoundingBox;
- (void) createSphericalBoundingVolumeFromBoundingBoxWithRadiusRatio: (float) ratio;


@end
