/**
 *  testCocosScene.h
 *  testCocos
 *
 *  Created by Luiz Fernando 2 on 1/20/14.
 *  Copyright Luiz Fernando 2 2014. All rights reserved.
 */


#import "CC3Scene.h"
#import "Connection.h"
/** A sample application-specific CC3Scene subclass.*/
@interface testCocosScene : CC3Scene <GameConnectionDelegate> {
}

@property BOOL flip;
@property (strong, nonatomic) NSMutableArray *charactersArray;
@property (strong, nonatomic) CC3Camera *cam;
@property (strong, nonatomic) NSMutableArray *lines;

@property int xTiles;
@property int yTiles;

//@property (strong, nonatomic) Connection *myConnection;

@end
