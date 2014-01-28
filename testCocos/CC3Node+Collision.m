//
//  CC3Node+Collision.m
//  testCocos
//
//  Created by Francesco Perrotti-Garcia on 1/24/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "CC3Node+Collision.h"

@implementation CC3Node (Collision)

- (void) createBoundingVolumeFromBoundingBox
{
    CC3NodeBoundingVolume *bv = [CC3NodeBoxBoundingVolume boundingVolumeFromBox:self.boundingBox];
    
    self.boundingVolume = bv;
    self.shouldUseFixedBoundingVolume = YES;
}

- (void) createSphericalBoundingVolumeFromBoundingBox
{
    [self createSphericalBoundingVolumeFromBoundingBoxWithRadiusRatio: 1.0f];
}

- (void) createSphericalBoundingVolumeFromBoundingBoxWithRadiusRatio: (float) ratio
{
    CC3NodeSphericalBoundingVolume *bv = [CC3NodeSphericalBoundingVolume boundingVolumeFromSphere:CC3SphereFromCircumscribingBox(self.boundingBox)];
    bv.radius *= ratio;
    self.boundingVolume = bv;
    self.shouldUseFixedBoundingVolume = YES;
}



@end
