/**
 *  testCocosScene.m
 *  testCocos
 *
 *  Created by Luiz Fernando 2 on 1/20/14.
 *  Copyright Luiz Fernando 2 2014. All rights reserved.
 */

#import "testCocosScene.h"
#import "CC3PODResourceNode.h"
#import "CC3ActionInterval.h"
#import "CC3MeshNode.h"
#import "CC3Camera.h"
#import "CC3Light.h"
#import "CC3Foundation.h"
#import "CC3UtilityMeshNodes.h"
#import "CC3Node+Collision.h"
#import "Player.h"

#define TILE_SZ 100.0f
@implementation testCocosScene

NSMutableArray *_walls;
CC3Node *_monkeyModel;
-(void) dealloc {
	[super dealloc];
}

/**
 * Constructs the 3D scene prior to the scene being displayed.
 *
 * Adds 3D objects to the scene, loading a 3D 'hello, world' message
 * from a POD file, and creating the camera and light programatically.
 *
 * When adapting this template to your application, remove all of the content
 * of this method, and add your own to construct your 3D model scene.
 *
 * You can also load scene content asynchronously while the scene is being displayed by
 * loading on a background thread. The
 *
 * NOTES:
 *
 * 1) To help you find your scene content once it is loaded, the onOpen method below contains
 *    code to automatically move the camera so that it frames the scene. You can remove that
 *    code once you know where you want to place your camera.
 *
 * 2) The POD file used for the 'hello, world' message model is fairly large, because converting a
 *    font to a mesh results in a LOT of triangles. When adapting this template project for your own
 *    application, REMOVE the POD file 'hello-world.pod' from the Resources folder of your project.
 */
-(void) initializeScene {
    [Connection myConnection];
    [Connection myConnection].delegate = self;
    
    _walls = [[NSMutableArray alloc] init];
    self.charactersArray = [[NSMutableArray alloc] init];
    self.flip = NO;
    self.isTouchEnabled = YES;
	// Create the camera, place it back a bit, and add it to the scene
	CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
	cam.location = cc3v( 0.0, 25.0, -15.0 );
//    cam set
    cam.targetLocation = cc3v(0, 0, 0);
    
	[self addChild: cam];

	// Create a light, place it back and to the left at a specific
	// position (not just directional lighting), and add it to the scene
	CC3Light* lamp = [CC3Light nodeWithName: @"Lamp"];
	lamp.location = cc3v( 0.0, 0.0, 10.0 );
	lamp.isDirectionalOnly = NO;
	[cam addChild: lamp];
    
    
    
	// Select an appropriate shader program for each mesh node in this scene now. If this step
	// is omitted, a shader program will be selected for each mesh node the first time that mesh
	// node is drawn. Doing it now adds some additional time up front, but avoids potential pauses
	// as each shader program is loaded as needed the first time it is needed during drawing.
	[self selectShaderPrograms];

	// With complex scenes, the drawing of objects that are not within view of the camera will
	// consume GPU resources unnecessarily, and potentially degrading app performance. We can
	// avoid drawing objects that are not within view of the camera by assigning a bounding
	// volume to each mesh node. Once assigned, the bounding volume is automatically checked
	// to see if it intersects the camera's frustum before the mesh node is drawn. If the node's
	// bounding volume intersects the camera frustum, the node will be drawn. If the bounding
	// volume does not intersect the camera's frustum, the node will not be visible to the camera,
	// and the node will not be drawn. Bounding volumes can also be used for collision detection
	// between nodes. You can create bounding volumes automatically for most rigid (non-skinned)
	// objects by using the createBoundingVolumes on a node. This will create bounding volumes
	// for all decendant rigid mesh nodes of that node. Invoking the method on your scene will
	// create bounding volumes for all rigid mesh nodes in the scene. Bounding volumes are not
	// automatically created for skinned meshes that modify vertices using bones. Because the
	// vertices can be moved arbitrarily by the bones, you must create and assign bounding
	// volumes to skinned mesh nodes yourself, by determining the extent of the bounding
	// volume you need, and creating a bounding volume that matches it. Finally, checking
	// bounding volumes involves a small computation cost. For objects that you know will be
	// in front of the camera at all times, you can skip creating a bounding volume for that
	// node, letting it be drawn on each frame. Since the automatic creation of bounding
	// volumes depends on having the vertex location content in memory, be sure to invoke
	// this method before invoking the releaseRedundantContent method.
	[self createBoundingVolumes];
	
	// Create OpenGL buffers for the vertex arrays to keep things fast and efficient, and to
	// save memory, release the vertex content in main memory because it is now redundant.
	[self createGLBuffers];
	[self releaseRedundantContent];

	
	// ------------------------------------------
	
	// That's it! The scene is now constructed and is good to go.
	
	// To help you find your scene content once it is loaded, the onOpen method below contains
	// code to automatically move the camera so that it frames the scene. You can remove that
	// code once you know where you want to place your camera.
	
	// If you encounter problems displaying your models, you can uncomment one or more of the
	// following lines to help you troubleshoot. You can also use these features on a single node,
	// or a structure of nodes. See the CC3Node notes for more explanation of these properties.
	// Also, the onOpen method below contains additional troubleshooting code you can comment
	// out to move the camera so that it will display the entire scene automatically.
	
	// Displays short descriptive text for each node (including class, node name & tag).
	// The text is displayed centered on the pivot point (origin) of the node.
//	self.shouldDrawAllDescriptors = YES;
	
	// Displays bounding boxes around those nodes with local content (eg- meshes).
//	self.shouldDrawAllLocalContentWireframeBoxes = YES;
	
	// Displays bounding boxes around all nodes. The bounding box for each node
	// will encompass its child nodes.
//	self.shouldDrawAllWireframeBoxes = YES;
	
	// If you encounter issues creating and adding nodes, or loading models from
	// files, the following line is used to log the full structure of the scene.
	LogInfo(@"The structure of this scene is: %@", [self structureDescription]);
	
	// ------------------------------------------
    
    //load the model content from the file
    [self addContentFromPODFile:@"suzanne.pod" withName:@"monkey"];
    _monkeyModel = [self getNodeNamed:@"monkey"];
    
    //remove this temp model from the world
    [self removeChild:_monkeyModel];
    
    [self readMapFile];
	[self createTerrain];
    [self createWalls];
    [self addPlayerCharacter];
    [self addPlayerCharacter];

    
}
-(void) addPlayerCharacter {
    Player *monkey = [[Player alloc] init];
    
    //copy the original model
    monkey.node = [_monkeyModel copy];
    
    //create bounding volume
    [monkey.node createSphericalBoundingVolumeFromBoundingBoxWithRadiusRatio:0.8f];
    monkey.node.shouldDrawBoundingVolume = YES;
    
    monkey.node.location = cc3v(0, 0, 50);
    
    monkey.node.rotationAxis = kCC3VectorUnitYPositive;
    monkey.node.scale = cc3v(10,10,10);
    
    //add to character array and add the node to the scene
    [self.charactersArray addObject:monkey];
    [self addChild:monkey.node];
}
-(void) readMapFile {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"map01"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    int lineSize = (int) [content rangeOfString: @"\n"].location + 1; //acha tamanho da linha pelo primeiro \n
    
    self.lines = [NSMutableArray arrayWithCapacity: (NSUInteger) 2];
    
    int initialPos = 0; //initR indica a posicao inicial da proxima "linha"
    
    for(int lineNumber = 0; initialPos < content.length; lineNumber++)
    {
        initialPos = lineSize*lineNumber; //calcula comeco da proxima linha
        if (initialPos >= content.length)
            continue;
        NSMutableString *nextLine;
        if(lineSize*(lineNumber+1) >= content.length) //caso da ultima linha, pega string a partir da posicao incial
        {
            nextLine = (NSMutableString *) [content substringFromIndex:(NSUInteger) initialPos];
            
        }
        else // se nao for a ultima linha, pega a substring a partir de initialPos e "corta" apenas caracteres ate \n seguinte
        {
            nextLine = (NSMutableString *) [[content substringFromIndex:(NSUInteger) initialPos] substringToIndex:(NSUInteger) lineSize - 1];
        }
        
        [self.lines addObject: nextLine]; //adiciona string a array de linhas
    }
    
    self.xTiles = [self.lines count];
    self.yTiles = [[self.lines firstObject] length] / 2 + 1;
    
}
-(void) createTerrain {
    //hocus pocus add grass
    
    const float LOCATION_Z = (0.0f);
    
    float xstart = (float)((self.xTiles * TILE_SZ) / 2.0f);
    float ystart = (float)((self.yTiles * TILE_SZ) / 2.0f);
    
    for (int i = 0; i < (int)self.xTiles; i++) {
        for (int j = 0; j < (int)self.yTiles; j++) {
            NSString * name = [NSString stringWithFormat:@"grass.png"];
            CCLOG(@"tile : %@", name);
            
            CC3Texture * texture = [CC3Texture textureFromFile: name];
            if( texture != nil) {
                CC3PlaneNode *tile = [CC3PlaneNode nodeWithName: name];
                CC3Texture * texture = [CC3Texture textureFromFile: name];
                
                tile.shouldCullBackFaces = NO;
                
                [tile populateAsCenteredRectangleWithSize: CGSizeMake(TILE_SZ, TILE_SZ) andTessellation:CC3TessellationMake(1, 1)];
                [tile setTexture: texture];
                [tile rotateByAngle:90 aroundAxis:kCC3VectorUnitXPositive];
                

                CC3Vector loc = cc3v((float)((i * TILE_SZ) - xstart), LOCATION_Z, (float)(((j * TILE_SZ) - ystart)));
                [tile setLocation: loc];
                [tile retainVertexLocations];
                
                
                [self addChild: tile];
                
                loc = [tile location];
                CCLOG(@"Added tile at : %f / %f / %f", loc.x, loc.y, loc.z);
                
            }
        }
    }
}

-(void) createWalls {
    
    const float LOCATION_Z = 0;
    float xstart = (float)((self.xTiles * TILE_SZ) / 2.0f);
    float ystart = (float)((self.yTiles* TILE_SZ) / 2.0f);

    //load the resource tiles from pod file
    CC3Node *wall = [CC3Node node];
    [self addContentFromPODFile:@"simpleCube2.pod" withName:@"wallCube"];
    CC3Node *wallCube = [self getNodeNamed:@"wallCube"];
    wallCube.scale = cc3v(49.5f, 80, 49.5f);
    
    //save original color for possible restore
    ccColor3B originalColor = wallCube.color;
    
    
    for (int i = 0; i < (int)self.xTiles; i++) {
        if (i >= [self.lines count])
            break;
        
        NSString *currentLine = [self.lines objectAtIndex:i];
        
        for (int j = 0; j < (int)self.yTiles; j++) {
            //lower
            if (2*j >= [currentLine length])
                break;
            char c = [currentLine characterAtIndex:2*j];
        
            //reads a character from the string, add accordingly.
            
            //c == 0 -> empty tile
            //c == 1 -> original color wall
            //c == 2 -> colored wall
            
            if (c == '3') {
                wallCube.location = cc3v((float)((i * TILE_SZ) - xstart) ,   (float)((j * TILE_SZ) - ystart)  - TILE_SZ/2, LOCATION_Z);
                [wall addChild:wallCube];
                wallCube = [wallCube copy];
            } else if (c == '2' || c == '1') {
                wallCube.location = cc3v((float)((i * TILE_SZ) - xstart) ,   LOCATION_Z, (float)((j * TILE_SZ) - ystart)  - TILE_SZ/2);
                //paint the tile a different color
                ccColor3B endColor = { rand() % 256 , rand() % 256, rand() % 256 };
                wallCube.color = endColor;
                [wall addChild:wallCube];
                [wallCube createBoundingVolumeFromBoundingBox];
//                wallCube.shouldDrawBoundingVolume = YES;
                [_walls addObject:wallCube];
                wallCube = [wallCube copy];
                //return to original color
                wallCube.color = originalColor;
            }
        }
    }
    
    [self addChild:wall];
}

/**
 * By populating this method, you can add add additional scene content dynamically and
 * asynchronously after the scene is open.
 *
 * This method is invoked from a code block defined in the onOpen method, that is run on a
 * background thread by the CC3GLBackgrounder available through the backgrounder property of
 * the viewSurfaceManager. It adds content dynamically and asynchronously while rendering is
 * running on the main rendering thread.
 *
 * You can add content on the background thread at any time while your scene is running, by
 * defining a code block and running it on the backgrounder of the viewSurfaceManager. The
 * example provided in the onOpen method is a template for how to do this, but it does not
 * need to be invoked only from the onOpen method.
 *
 * Certain assets, notably shader programs, will cause short, but unavoidable, delays in the
 * rendering of the scene, because certain finalization steps from shader compilation occur on
 * the main thread. Shaders and certain other critical assets should be pre-loaded in the
 * initializeScene method prior to the opening of this scene.
 */
-(void) addSceneContentAsynchronously {}


#pragma mark Updating custom activity

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides your app with an opportunity to perform update activities before
 * any changes are applied to the transformMatrix of the 3D nodes in the scene.
 *
 * For more info, read the notes of this method on CC3Node.
 */
-(void) updateBeforeTransform: (CC3NodeUpdatingVisitor*) visitor
{

}

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides your app with an opportunity to perform update activities after
 * the transformMatrix of the 3D nodes in the scen have been recalculated.
 *
 * For more info, read the notes of this method on CC3Node.
 */
-(void) updateAfterTransform: (CC3NodeUpdatingVisitor*) visitor
{
    [self checkForCollisions];
}


#pragma mark Scene opening and closing

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene is first displayed.
 *
 * This method is a good place to invoke one of CC3Camera moveToShowAllOf:... family
 * of methods, used to cause the camera to automatically focus on and frame a particular
 * node, or the entire scene.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onOpen {
	
	// Add additional scene content dynamically and asynchronously on a background thread
	// after the scene is open and rendering has begun on the rendering thread. We use the
	// GL backgrounder provided by the viewSurfaceManager to accomplish this. Asynchronous
	// loading must be initiated after the scene has been attached to the view. It cannot
	// be started in the initializeScene method. However, you do not need to start it only
	// in this onOpen method. You can use the code here as a template for use whenever your
	// app requires background content loading.
	[self.viewSurfaceManager.backgrounder runBlock: ^{
		[self addSceneContentAsynchronously];
	}];

	// Move the camera to frame the scene. The resulting configuration of the camera is output as
	// a [debug] log message, so you know where the camera needs to be in order to view your scene.
	[self.activeCamera moveWithDuration: 1.0 toShowAllOf: self withPadding: 0.0f];
//    [self.activeCamera setTarget:_monkey];
//    [self.activeCamera setShouldTrackTarget:YES];
	// Uncomment this line to draw the bounding box of the scene.
//	self.shouldDrawWireframeBox = YES;
}

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene has been removed from display.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onClose {}


#pragma mark Drawing

/**
 * Template method that draws the content of the scene.
 *
 * This method is invoked automatically by the drawScene method, once the 3D environment has
 * been established. Once this method is complete, the 2D rendering environment will be
 * re-established automatically, and any 2D billboard overlays will be rendered. This method
 * does not need to take care of any of this set-up and tear-down.
 *
 * This implementation simply invokes the default parent behaviour, which turns on the lighting
 * contained within the scene, and performs a single rendering pass of the nodes in the scene 
 * by invoking the visit: method on the specified visitor, with this scene as the argument.
 * Review the source code of the CC3Scene drawSceneContentWithVisitor: to understand the
 * implementation details, and as a starting point for customization.
 *
 * You can override this method to customize the scene rendering flow, such as performing
 * multiple rendering passes on different surfaces, or adding post-processing effects, using
 * the template methods mentioned above.
 *
 * Rendering output is directed to the render surface held in the renderSurface property of
 * the visitor. By default, that is set to the render surface held in the viewSurface property
 * of this scene. If you override this method, you can set the renderSurface property of the
 * visitor to another surface, and then invoke this superclass implementation, to render this
 * scene to a texture for later processing.
 *
 * When overriding the drawSceneContentWithVisitor: method with your own specialized rendering,
 * steps, be careful to avoid recursive loops when rendering to textures and environment maps.
 * For example, you might typically override drawSceneContentWithVisitor: to include steps to
 * render environment maps for reflections, etc. In that case, you should also override the
 * drawSceneContentForEnvironmentMapWithVisitor: to render the scene without those additional
 * steps, to avoid the inadvertenly invoking an infinite recursive rendering of a scene to a
 * texture while the scene is already being rendered to that texture.
 *
 * To maintain performance, by default, the depth buffer of the surface is not specifically
 * cleared when 3D drawing begins. If this scene is drawing to a surface that already has
 * depth information rendered, you can override this method and clear the depth buffer before
 * continuing with 3D drawing, by invoking clearDepthContent on the renderSurface of the visitor,
 * and then invoking this superclass implementation, or continuing with your own drawing logic.
 *
 * Examples of when the depth buffer should be cleared are when this scene is being drawn
 * on top of other 3D content (as in a sub-window), or when any 2D content that is rendered
 * behind the scene makes use of depth drawing. See also the closeDepthTestWithVisitor:
 * method for more info about managing the depth buffer.
 */
-(void) drawSceneContentWithVisitor: (CC3NodeDrawingVisitor*) visitor {
	[super drawSceneContentWithVisitor: visitor];
}


#pragma mark Handling touch events 

/**
 * This method is invoked from the CC3Layer whenever a touch event occurs, if that layer
 * has indicated that it is interested in receiving touch events, and is handling them.
 *
 * Override this method to handle touch events, or remove this method to make use of
 * the superclass behaviour of selecting 3D nodes on each touch-down event.
 *
 * This method is not invoked when gestures are used for user interaction. Your custom
 * CC3Layer processes gestures and invokes higher-level application-defined behaviour
 * on this customized CC3Scene subclass.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) touchEvent: (uint) touchType at: (CGPoint) touchPoint {
    
    if (touchType != UITouchPhaseBegan)
        return;
    //using to change camera positions, alter as you need
    
    static int position = 0;
    CC3Vector direction;
    
    switch (position) {
        case 0:
            direction = cc3v(1, 0, 1);
            break;
        case 1:
            direction = cc3v(0, 1, 1);
            break;
        case 2:
            direction = cc3v(-1, 1, 1);
            break;
        case 3:
            direction = cc3v(0, 0, 1);
        case 4:
            direction = cc3v(1, 0, 0);
            break;
    
        default:
            break;
    }
    [self.activeCamera moveWithDuration:3.0f toShowAllOf:self fromDirection:direction];
    
    position = (position + 1) % 5;
    [self.activeCamera setTargetLocation:kCC3VectorZero];
}

/**
 * This callback template method is invoked automatically when a node has been picked
 * by the invocation of the pickNodeFromTapAt: or pickNodeFromTouchEvent:at: methods,
 * as a result of a touch event or tap gesture.
 *
 * Override this method to perform activities on 3D nodes that have been picked by the user.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) nodeSelected: (CC3Node*) aNode byTouchEvent: (uint) touchType at: (CGPoint) touchPoint {

}



#pragma mark - GameConnectionDelegate
//Methods that handle multipeer controller interaction

-(void) otherPlayerPressed:(ButtonPressMessage *)buttonPressMessage {
    
    if ([[buttonPressMessage playerNumber] intValue] >= [self.charactersArray count])
        return;
    
    
    NSLog(@"%@ player: %@" , [buttonPressMessage buttonNumber], [buttonPressMessage playerNumber]);
    
    Player* character = [self.charactersArray objectAtIndex:[[buttonPressMessage playerNumber] intValue]];
    int buttonNumberInt = [[buttonPressMessage buttonNumber] intValue];
    
    NSLog(@"%@" ,[character.node name]);
    CC3Vector moveDirection;
    CCActionInterval *move;

    const int speed = 10;
    //sets the direction of movement based on the number passed by the connexion, rotates the dragon to face the direction of movement.
    switch (buttonNumberInt) {
        //up button
        case 0:
            if(character.node.rotationAngle != 0) {
                CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:0];
                [character.node runAction:rotate];
            }
            moveDirection = cc3v(0, 0, speed);
            move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
            [character.node runAction:[CCRepeatForever actionWithAction:move] withTag:0];
            [character.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
            
            break;
        //right button
        case 1:
            if(character.node.rotationAngle != -90) {
                CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:-90];
                [character.node runAction:rotate];
            }
            moveDirection = cc3v(-speed, 0, 0);
            move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
            [character.node runAction:[CCRepeatForever actionWithAction:move] withTag:0];
            [character.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
            
            break;
        //bottom button
        case 2:
            if(character.node.rotationAngle != 180) {
                CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:180];
                [character.node runAction:rotate];
            }
            
            moveDirection = cc3v(0, 0, -speed);
            move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
            [character.node runAction:[CCRepeatForever actionWithAction:move] withTag:0];
            [character.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
            break;
        //left button
        case 3:
            if(character.node.rotationAngle != 90) {
                CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:90];
                [character.node runAction:rotate];
            }
            
            moveDirection = cc3v(speed, 0, 0);
            move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
            [character.node runAction:[CCRepeatForever actionWithAction:move]withTag:0];
            [character.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
            break;
        //movement end
        default:
            [character.node stopActionByTag:0];
            [character.node stopActionByTag:1];
            break;
    }
}

/**
 * Check for collisions.
 *
 * Invoke the doesIntersectNode: method to determine whether the player has
 * collided with the wall or with another player.
 *
 * If the player is colliding, it may do so for several update frames.
 * On each frame, we need to determine whether it is heading towards something. If it is we stop the moving action. 
 *
 * All movement is handled by CCActions.
 *
 * The effect is to see the player collide with something, and stop.
 */
-(void) checkForCollisions
{
    for (Player *player in self.charactersArray)
    {
        //For each wall cube:
        for (CC3Node *wall in _walls)
        {
            // Test whether the player intersects the wall.
            if ([player.node.boundingVolume doesIntersect:wall.boundingVolume])
            {
                //If it does I stop their movement
                [player.node stopAllActions];
                player.node.location = player.oldLocation;
                player.node.rotationAngle = player.oldRotationAngle;
                break;
            }
        }
        player.oldLocation = player.node.location;
        player.oldRotationAngle = player.node.rotationAngle;
    }
}

@end

