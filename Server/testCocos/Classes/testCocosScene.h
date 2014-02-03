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
@interface testCocosScene : CC3Scene <GameConnectionDelegate>
{
    
}

/**
 * Add property description here
 */
@property BOOL flip;

/**
 * Add property description here
 */
@property (strong, nonatomic) NSMutableArray *charactersArray;

/**
 * Add property description here
 */
@property (strong, nonatomic) CC3Camera *cam;

/**
 * Add property description here
 */
//@property (strong, nonatomic) NSMutableArray *lines;
//
//#warning A pragma mark may be necessary here
//
///**
// * Add property description here
// */
//@property int xTiles;
//
///**
// * Add property description here
// */
//@property int yTiles;

//@property (strong, nonatomic) Connection *myConnection;

@end
