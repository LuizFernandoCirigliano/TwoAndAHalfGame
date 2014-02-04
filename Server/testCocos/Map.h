//
//  Map.h
//  TwoAndAHalfGame
//
//  Created by Luiz Fernando 2 on 2/3/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGPointExtension.h"

@interface Map : NSObject

/**
 * Add property description here
 */
@property (strong, nonatomic) NSMutableArray *lines;

@property float tileSizeX;
@property float tileSizeZ;

@property float mapSizeX;
@property float mapSizeZ;

/**
 * Add property description here
 */
@property int xTileCount;

/**
 * Add property description here
 */
@property int zTileCount;

@property (nonatomic) CGPoint playerASpawnPoint;
@property (nonatomic) CGPoint playerBSpawnPoint;
@property (nonatomic) CGPoint playerCSpawnPoint;
@property (nonatomic) CGPoint playerDSpawnPoint;
@property float scale;

+ (Map *) myMap;

- (void) readMapFile;

-(void) setSizesWithMapX : (float) xSize andMapZ: (float) zSize;
-(CGPoint) locationInMapWithPosition: (CGPoint) position;
-(CGPoint) positionInMapWithLocation: (CGPoint) location;
-(char) contentOfMapAtLocation: (CGPoint) location;
@end
