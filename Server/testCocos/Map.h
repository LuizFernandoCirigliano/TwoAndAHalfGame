//
//  Map.h
//  TwoAndAHalfGame
//
//  Created by Luiz Fernando 2 on 2/3/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TILE_SZ 100.0f

@interface Map : NSObject

/**
 * Add property description here
 */
@property (strong, nonatomic) NSMutableArray *lines;


/**
 * Add property description here
 */
@property int xTiles;

/**
 * Add property description here
 */
@property int yTiles;

+ (Map *) myMap;

- (void) readMapFile;
@end
