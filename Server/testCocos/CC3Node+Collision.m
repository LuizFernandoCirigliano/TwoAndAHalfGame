//
//  CC3Node+Collision.m
//  testCocos
//
//  Created by Francesco Perrotti-Garcia on 1/24/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "CC3Node+Collision.h"
#import "Map.h"

@implementation CC3Node (Collision)

/**
 * Allocates and initializes an autoreleased instance of the
 * mesh bounding volume from its bounding box,
 * and sets the shouldUseFixedBoundingVolume
 * property to NO.
 */
- (void) createBoundingVolumeFromBoundingBox
{
    //Create bounding volume
    CC3NodeBoundingVolume *bv = [CC3NodeBoxBoundingVolume boundingVolumeFromBox:self.boundingBox];
    //Set bounding volume
    self.boundingVolume = bv;
    //Use fixed bounding volume
    self.shouldUseFixedBoundingVolume = YES;
}

/**
 * Allocates and initializes an autoreleased instance of the
 * mesh spherical bounding volume from its bounding box,
 * and sets the shouldUseFixedBoundingVolume
 * property to NO.
 */
- (void) createSphericalBoundingVolumeFromBoundingBox
{
    [self createSphericalBoundingVolumeFromBoundingBoxWithRadiusRatio: 1.0f];
}

/**
 * Allocates and initializes an autoreleased instance of the
 * mesh spherical bounding volume from its bounding box,
 * with a given radius ratio
 * and sets the shouldUseFixedBoundingVolume
 * property to NO.
 \param ratio The ratio of the ratius in the spherical bounding volume
 */
- (void) createSphericalBoundingVolumeFromBoundingBoxWithRadiusRatio: (float) ratio
{
    //Create box
    CC3Box boundingBox = self.boundingBox;
    //Create sphere
    CC3Sphere boundingSphere = CC3SphereFromCircumscribingBox(boundingBox);
    //Set sphere radius
    boundingSphere.radius *= ratio;
    //Create boudning volume from sphere
    CC3NodeSphericalBoundingVolume *boundingVolume = [CC3NodeSphericalBoundingVolume boundingVolumeFromSphere:boundingSphere];
    //Set bounding volume
    self.boundingVolume = boundingVolume;
    //Use fixed bounding volume
    self.shouldUseFixedBoundingVolume = YES;
}


/**
 * Returns whether the node should move considering its current and locationa and the map content
 */
- (BOOL) shouldMove
{
    CGPoint oldPosition = CGPointMake(self.oldLocation.x, self.oldLocation.z);
    CGPoint position = CGPointMake(self.location.x, self.location.z);

#warning Possible incomplete method implementation
    
    
    return YES;
}



@end
