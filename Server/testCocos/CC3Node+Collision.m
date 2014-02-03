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
 \param ratio The ratio of the radius in the spherical bounding volume
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
 * Returns whether the node should move considering its location and the map
 */
- (BOOL) shouldMove
{
    CGPoint position = CGPointMake(self.location.x, self.location.z);
    
    CC3BoundingVolume *boundingVolume = self.boundingVolume;
    if ([boundingVolume isKindOfClass:[CC3NodeSphericalBoundingVolume class]])
    {
        GLfloat radius = ((CC3NodeSphericalBoundingVolume*)boundingVolume).radius;
        
        CGPoint bounds[4] =    {CGPointMake(self.location.x         , self.location.z - radius), //UP
                                CGPointMake(self.location.x + radius, self.location.z         ), //RIGHT
                                CGPointMake(self.location.x         , self.location.z + radius), //DOWN
                                CGPointMake(self.location.x - radius, self.location.z         )};//LEFT
    
        CGPoint locationInMap[4];
        
//        for (int i = 0; i < 4; i++)
//        {
//            locationInMap[i]  = [Map locationInMapWithPosition: bounds[i]];
//            
//            if ([Map contentOfMapAtLocation: locationInMap[i]] != '0') //If the new location is not free
//            {
//                return NO; //The node should not move
//            }
//        }
        
        return YES;
    }
    else
    {
        //If the bounding volume is not spherical than the node is free to move
        return YES;
    }
    
}



@end
