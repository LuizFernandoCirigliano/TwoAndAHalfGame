/**
 *  testCocosScene.m
 *  testCocos
 *
 *  Created by Luiz Fernando 2 on 1/20/14.
 *  Copyright Luiz Fernando 2 2014. All rights reserved.
 */

#import "testCocosScene.h"
#import "testCocosLayer.h"
#import "CC3PODResourceNode.h"
#import "CC3ActionInterval.h"
#import "CC3MeshNode.h"
#import "CC3Camera.h"
#import "CC3Light.h"
#import "CC3Foundation.h"
#import "CC3UtilityMeshNodes.h"
#import "CC3Node+Collision.h"
#import "Player.h"
#import "CC3BillBoard.h"
#import "CC3ParametricMeshNodes.h"
#import "CC3MeshParticles.h"
#import "Map.h"
#import "Game.h"
#import "SimpleAudioEngine.h"

#define COLLISION_DEBUG 0
@interface testCocosScene()

@property (nonatomic) BOOL collisionEnabled;


@end


#define CAMERA_ANGLE cc3v(0.0f,20.0f,15.0f)
#define COLISSION_CHECK_INTERVAL 30.0f
#define playerScale 22

@implementation testCocosScene

NSMutableArray *_walls;

CC3Node *_playerModel;

CC3Node *_allCharacters;

CC3Node *_mazeMap;

CC3Node *_bonusCoin;

CC3Node *_bonusCoinCollection;

CC3MeshParticleEmitter *_emitter;

NSMutableDictionary *_coinDictionary;

NSMutableArray *_playerArray;

NSTimer *_cameraPlayersTimer;

-(void) dealloc
{
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
-(void) initializeScene
{

    //initializes variables
    [self performInitializations];

	// Create a light, place it back and to the left at a specific
	// position (not just directional lighting), and add it to the scene
	CC3Light* lamp = [CC3Light nodeWithName: @"Lamp"];
	lamp.location = cc3v( 0.0, 10000.0, 5000.0 );
	lamp.isDirectionalOnly = NO;
	
    
    
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
//    [self addContentFromPODFile:@"boy3.pod" withName:@"player"];
//    _playerModel = [self getNodeNamed:@"player"];
    
    
    //remove this temp model from the world
//    [self removeChild:_playerModel];
    
    [[Map myMap] readMapFile];
    
    //leave the mazeWalls as the first method

    
    [self addMazeWalls];
    
    for (int i = 0; i < 4 ; i++) {
        [self addPlayerCharacterWithNumber: i];
    }
    
    [self addChild:_allCharacters];

    [self createCoinParticles];
    [self addCamera];
//    [self.activeCamera addChild:lamp];
    
    [self addChild:lamp];
    // Create OpenGL buffers for the vertex arrays to keep things fast and efficient, and to
	// save memory, release the vertex content in main memory because it is now redundant.
	[self createGLBuffers];
    [self releaseRedundantContent];
    
    self.collisionEnabled = YES;
}


//called in initializeScene
-(void)createCoinParticles{

    CC3MeshNode *particleTemplate = [CC3MeshNode node];
    
    const float partSize = 20;
    [particleTemplate populateAsSolidBox:CC3BoxMake(0, 0, 0, partSize, partSize , partSize)];
    ccColor3B gold = {255,215,0};
    
    particleTemplate.color = gold;
    
    _emitter = [CC3MeshParticleEmitter node];
    _emitter.tag = 0; //index of current color
    _emitter.location = kCC3VectorZero;
    _emitter.particleTemplate = particleTemplate;
    _emitter.particleClass = [CC3MeshParticle class];
    _emitter.vertexContentTypes = kCC3VertexContentLocation | kCC3VertexContentColor | kCC3VertexContentNormal;
    [self addChild:_emitter];
    
    for (int i = 0; i < [[Map myMap] xTileCount]; i++) {
        for (int j = 0; j < [[Map myMap] zTileCount]; j++) {
            NSLog(@"%c", [[Map myMap] contentOfMapAtLocation:CGPointMake(i, j)]);
            if ([[Map myMap] contentOfMapAtLocation:CGPointMake(i, j)] == '0') {
                CGPoint position = [[Map myMap] positionInMapWithLocation:CGPointMake(i, j)];
                CC3Vector pos = cc3v(position.x, 50, position.y);
                CC3MeshParticle *particle = (CC3MeshParticle*)[_emitter emitParticle];

                particle.location = pos;
                particle.color = gold;
                
                [_coinDictionary setObject:particle forKey:[NSString stringWithFormat:@"%d-%d", i, j]] ;

            }
        }
    }
}

//all variable and property initializations go here
-(void) performInitializations {
    [Connection myConnection];
    [Connection myConnection].delegate = self;
    _allCharacters = [CC3Node node];

    
    _walls = [[NSMutableArray alloc] init]; //DO NOT USE [NSMutableArray array], if you do the app WILL crash.
    
    self.flip = NO;
    self.isTouchEnabled = YES;
    
    [[Game myGame] configureGame];
    
    _playerArray = [[Game myGame] playerArray];
    _coinDictionary = [[NSMutableDictionary alloc] init];

    _bonusCoinCollection  = [CC3Node node];
    [self addChild:_bonusCoinCollection];
    
    [self addContentFromPODFile:@"coin9.pod" withName:@"bonusCoinModel"];
    _bonusCoin = [[self getNodeNamed:@"bonusCoinModel"] copy];
    _bonusCoin.scale = cc3v(50, 50, 50);
    [_bonusCoin createBoundingVolumeFromBoundingBox];
    _bonusCoin.shouldUseFixedBoundingVolume = YES;
    [self removeChild:[self getNodeNamed:@"bonusCoinModel"]];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

-(void) addCamera {
    // Create the camera, place it back a bit, and add it to the scene
	CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
    cam.location = cc3v(0,10, [[Map myMap] mapSizeZ]* 2);
    
    cam.targetLocation = cc3v(0, 0, 0);
    
    
    cam.hasInfiniteDepthOfField = YES;
    cam.nearClippingDistance = 1000;
    
	[self addChild: cam];
    
}
-(void) createTestTerrain
{
    //hocus pocus add grass
    
    const float LOCATION_Z = (0.0f);
    
    for (int i = 0; i < [[Map myMap] xTileCount]; i++)
    {
        for (int j = 0; j < [[Map myMap] zTileCount]; j++)
        {
            NSString * name = [NSString stringWithFormat:@"grass.png"];
            CCLOG(@"tile : %@", name);
            
            CC3Texture * texture = [CC3Texture textureFromFile: name];
            if( texture != nil) {
                CC3PlaneNode *tile = [CC3PlaneNode nodeWithName: name];
                
                tile.shouldCullBackFaces = NO;
                
                [tile populateAsCenteredRectangleWithSize: CGSizeMake ([[Map myMap] tileSizeX], [[Map myMap] tileSizeZ]) andTessellation:CC3TessellationMake(1, 1)];

                
                ccColor3B color= {rand() % 255, rand() % 255, rand() % 255};
                [tile setColor:color];
                [tile rotateByAngle:90 aroundAxis:kCC3VectorUnitXPositive];
//                [tile setT]
                
                CGPoint position = [[Map myMap] positionInMapWithLocation:CGPointMake(i, j)];
                CC3Vector pos = cc3v(position.x, LOCATION_Z, position.y);
                [tile setLocation: pos];
                [tile retainVertexLocations];
                
                
                [self addChild: tile];
                
            }
        }
    }
}



/**
 *
 * Add method description here
 *
 */

-(void) addMazeWalls {
    //Add maze map mesh
    [self addContentFromPODFile:@"school.pod" withName:@"school"];
    _mazeMap = [self getNodeNamed:@"school"];

    _mazeMap.scale = cc3v(200,200,200);
    

    [[Map myMap] setSizesWithMapX:_mazeMap.boundingBox.maximum.x*_mazeMap.scale.x*2  andMapZ:_mazeMap.boundingBox.maximum.z*2*_mazeMap.scale.z];
    [[Map myMap] setScale:200];
    
    _mazeMap.shouldCastShadows = YES;
    _mazeMap.shouldUseLighting = YES;

    _mazeMap.shouldCullFrontFaces = NO;

    [self addChild:_mazeMap];
    
    [self addContentFromPODFile:@"schoolentrance_textured.pod" withName:@"schoolEntrance"];
    CC3Node *entrance = [self getNodeNamed:@"schoolEntrance"];
    
    entrance.scale = cc3v(200, 200, 200);
    entrance.location = cc3v(-entrance.boundingBox.maximum.x*entrance.scale.x/2, 0, [[Map myMap] mapSizeZ] / 2 + entrance.boundingBox.maximum.z*entrance.scale.z*2.5/3);
}

-(void) addBonusCoin {
    
    CC3Node *coin = [_bonusCoin copy];
    int i, j;
    
    do {
        i = rand() % [[Map myMap] xTileCount];
        j = rand() % [[Map myMap] zTileCount];
    } while ([[Map myMap] contentOfMapAtLocation:CGPointMake(i, j)] != '0');
    
    CGPoint position = [[Map myMap] positionInMapWithLocation:CGPointMake(i, j)];
    coin.location = cc3v(position.x, 5000, position.y) ;
    CCActionInterval *moveCoin = [CC3MoveTo actionWithDuration:1.0f moveTo:cc3v(position.x, 50, position.y)];
    [coin runAction: moveCoin];
    
//    CCActionInterval *rotateCoin = [CC3RotateByAngle actionWithDuration:1.0f rotateByAngle:30];
//    [coin runAction:[CCRepeatForever actionWithAction:rotateCoin]];
    
    [_bonusCoinCollection addChild:coin];
    
}

-(void) addPlayerCharacterWithNumber:(NSInteger) number
{
    Player *player = [[Player alloc] initWithIndex: [_playerArray count]];
    
    NSString *modelString;
    switch (number) {
        case 0:
        case 2:
            modelString = @"boy3.pod";
            break;
        case 1:
        case 3:
            modelString = @"marcelo_model_low.pod";
            break;
    }
    //copy the original model
    [self addContentFromPODFile:modelString withName:[NSString stringWithFormat:@"player%d",number]];
    player.node = [[self getNodeNamed:[NSString stringWithFormat:@"player%d",number]] copy];
    //create bounding volume
    [player.node createSphericalBoundingVolumeFromBoundingBoxWithRadiusRatio:0.3f];
    
#if COLLISION_DEBUG
    monkey.node.shouldDrawBoundingVolume = YES;
#endif
    
    //temporary spawn position methods, replace with positions on map text file
    CGPoint spawnPoint;
    switch ([_playerArray count]) {
        case 0:
            spawnPoint = [[Map myMap] positionInMapWithLocation:CGPointMake(1,1)];
            break;
        case 1:
            spawnPoint = [[Map myMap] positionInMapWithLocation:CGPointMake(57,37)];
            break;
        case 2:
            spawnPoint = [[Map myMap] positionInMapWithLocation:CGPointMake(1,37)];
            break;
        case 3:
            spawnPoint = [[Map myMap] positionInMapWithLocation:CGPointMake(57,1)];
            break;
        default:
            break;
    }
    
    player.node.location = cc3v(spawnPoint.x, 0 , spawnPoint.y) ;
    
    player.node.rotationAxis = kCC3VectorUnitYPositive;
    player.node.scale = cc3v(playerScale, playerScale, playerScale);
    
    //Add Identifier on Player
    //Make a 2D sprite with image = player's number
    CCSprite *markerSprite = [CCSprite spriteWithFile: [NSString stringWithFormat:@"p%d.png",[_playerArray count]+1]];
    //Add sprite to billboard
    CC3Billboard *marker = [CC3Billboard nodeWithName: @"TouchSpot" withBillboard: markerSprite];
    [marker setScale:cc3v(0.1f, 0.1f, 0.1f)];
    marker.location = cc3v(0,25,0);
    //Always face the camera
    
    marker.shouldAutotargetCamera = YES;
    [marker setIsTouchEnabled:NO];
    
    [player.node addChild:marker];

    //add to character array and add the node to the scene
    [_playerArray addObject:player];
    
    [_allCharacters addChild:player.node];

    
}

/**
 * Add method description here
 *
 */
-(void) createTerrain
{
    //hocus pocus add grass
    const float LOCATION_Z = (0.0f);
    
    NSString * name = [NSString stringWithFormat:@"grass.png"];
    CCLOG(@"tile : %@", name);
    
    CC3Texture * texture = [CC3Texture textureFromFile: name];
    
    int xTiles = [[Map myMap] xTileCount];
    int zTiles = [[Map myMap] zTileCount];
    if( texture != nil)
    {
        CC3PlaneNode *tile = [CC3PlaneNode nodeWithName: name];
        CC3Texture * texture = [CC3Texture textureFromFile: name];
                [tile rotateByAngle:90 aroundAxis:kCC3VectorUnitXPositive];
        [tile populateAsCenteredRectangleWithSize: CGSizeMake([Map myMap].tileSizeX*xTiles, [Map myMap].tileSizeZ*zTiles) andTessellation:CC3TessellationMake(0.1f, 0.1f)];
    
        tile.shouldCullBackFaces = NO;


        [tile setTexture: texture];


        CC3Vector loc = cc3v(0, LOCATION_Z, 0);
        [tile setLocation: loc];
        [tile retainVertexLocations];
        
        [self addChild: tile];
    }
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
    //"Bushwick Tarantella Loop" Kevin MacLeod (incompetech.com)
    //    Licensed under Creative Commons: By Attribution 3.0
    //http://creativecommons.org/licenses/by/3.0/
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bkgMusic.mp3" loop:YES];
    
    
    
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
 
    Game *game = [Game myGame];
    game.hudLayer = (testCocosLayer *)self.cc3Layer;
    
    //schedule camera movements for the opening scene
    [self.activeCamera moveToShowAllOf:self fromDirection:cc3v(0, 0, 1)];
    [self performSelector:@selector(zoomCameraOnObject:) withObject:[[_playerArray firstObject] node] afterDelay:6.0f];
    [self performSelector:@selector(zoomCameraOnObject:) withObject:[[_playerArray lastObject] node] afterDelay:9.0f];
    [self performSelector:@selector(zoomCameraOnObject:) withObject:self afterDelay:12.0f];
    [self performSelector:@selector(startZoomingOnPlayers) withObject:nil  afterDelay:16.0f];
    
    
    [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(addBonusCoin) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:[[Game myGame] roundDuration] target:self selector:@selector(endGame) userInfo:nil repeats:NO];
    
	// Uncomment this line to draw the bounding box of the scene.
//	self.shouldDrawWireframeBox = YES;
}
-(void) zoomCameraOnPlayers {
    NSLog(@"moving camera");
    [self.activeCamera moveWithDuration:0.5f toShowAllOf:_allCharacters fromDirection:CAMERA_ANGLE];
}

-(void) zoomCameraOnObject: (CC3Node *)object {
    NSLog (@"camera luz acao")  ;
    [self.activeCamera moveWithDuration:2.0f toShowAllOf:object fromDirection:CAMERA_ANGLE];
}

-(void) startZoomingOnPlayers {
    _cameraPlayersTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(zoomCameraOnPlayers) userInfo:nil repeats:YES] ;
}

-(void) endGame {
    [_cameraPlayersTimer invalidate];
    Player *winner = [[Game myGame] topScorer];
    
    self.collisionEnabled = NO;
    winner.node.location = cc3v(winner.node.location.x, 300, winner.node.location.z);
    winner.node.scale = cc3v(2*playerScale, 2*playerScale, 2*playerScale);
    
    //focus camera on the winner
    [self.activeCamera moveWithDuration:1.0f toShowAllOf:winner.node fromDirection:cc3v(0, 0, 1)];
    self.activeCamera.target = winner.node;
    self.activeCamera.shouldTrackTarget = YES;
    
    //animations to run on the winning player
    [winner.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
    CCActionInterval *rotateAction = [CC3RotateByAngle actionWithDuration:1.0f rotateByAngle:-30.0f];
    [winner.node runAction:[CCRepeatForever actionWithAction:rotateAction]];
    
    //display player winner message
    [[[Game myGame] hudLayer] displayWinnerMessageWithNumber:winner.index];
    
    //warn the controllers that the game is over
    NSData *data = [[[EndRoundMessage alloc] init] archiveData];
    [[Connection myConnection] sendData:data];
    
    [[[Connection myConnection] advertiser] stopAdvertisingPeer];
    
    [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(restartScene) userInfo:nil repeats:NO];
}

-(void) restartScene {
    CCScene *currentScene = [CCDirector sharedDirector].runningScene;
    CCScene *newScene = [[[currentScene class] alloc] init];
    [[CCDirector sharedDirector] replaceScene:newScene];
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
-(void) drawSceneContentWithVisitor: (CC3NodeDrawingVisitor*) visitor
{
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
/**
 * Add method description here!
 *
 \param buttonPressMessage Parameter Description
 */
-(void) otherPlayerPressed:(ButtonPressMessage *)buttonPressMessage
{
    
    if ([[buttonPressMessage playerNumber] intValue] >= [_playerArray count])
    {
        return;
    }
    
    
    Player* character = [_playerArray objectAtIndex:[[buttonPressMessage playerNumber] intValue]];
    int buttonNumberInt = [[buttonPressMessage buttonNumber] intValue];
    
    CC3Vector moveDirection;
    CCActionInterval *move;

    const int speed = 30;
    //sets the direction of movement based on the number passed by the connexion, rotates the dragon to face the direction of movement.
    switch (buttonNumberInt)
    {
        //up button
        case 2:
            if(character.node.rotationAngle != 0)
            {
                CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:0];
                [character.node runAction:rotate];
            }
            moveDirection = cc3v(0, 0, speed);
            character.direction = Up;
            move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
            [character.node runAction:[CCRepeatForever actionWithAction:move] withTag:0];
            [character.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
            
            break;
        //right button
        case 3:
            if(character.node.rotationAngle != -90)
            {
                CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:-90];
                [character.node runAction:rotate];
            }
            moveDirection = cc3v(-speed, 0, 0);
            character.direction = Right;
            move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
            [character.node runAction:[CCRepeatForever actionWithAction:move] withTag:0];
            [character.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
            
            break;
        //bottom button
        case 0:
            if(character.node.rotationAngle != 180)
            {
                CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:180];
                [character.node runAction:rotate];
            }
            
            moveDirection = cc3v(0, 0, -speed);
            character.direction = Down;
            move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
            [character.node runAction:[CCRepeatForever actionWithAction:move] withTag:0];
            [character.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
            break;
        //left button
        case 1:
            if(character.node.rotationAngle != 90)
            {
                CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:90];
                [character.node runAction:rotate];
            }
            
            moveDirection = cc3v(speed, 0, 0);
            character.direction = Left;
            move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
            [character.node runAction:[CCRepeatForever actionWithAction:move]withTag:0];
            [character.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
            break;
        //upright button
        case 30:
            if(character.node.rotationAngle != -45)
            {
                CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:-45];
                [character.node runAction:rotate];
            }
            
            moveDirection = cc3v(-speed/sqrt(2.0f), 0, speed/sqrt(2.0f));
            character.direction = Other;
            move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
            [character.node runAction:[CCRepeatForever actionWithAction:move]withTag:0];
            [character.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
            break;
        //downright button
        case 40:
            if(character.node.rotationAngle != -135)
            {
                CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:-135];
                [character.node runAction:rotate];
            }
            
            moveDirection = cc3v(-speed/sqrt(2.0f), 0, -speed/sqrt(2.0f));
            character.direction = Other;
            move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
            [character.node runAction:[CCRepeatForever actionWithAction:move]withTag:0];
            [character.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
            break;
        //downleft button
        case 10:
            if(character.node.rotationAngle != 135)
            {
                CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:135];
                [character.node runAction:rotate];
            }
            
            moveDirection = cc3v(speed/sqrt(2.0f), 0, -speed/sqrt(2.0f));
            move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
            character.direction = Other;
            [character.node runAction:[CCRepeatForever actionWithAction:move]withTag:0];
            [character.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
            break;
        //upleft button
        case 20:
            if(character.node.rotationAngle != 45)
            {
                CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:45];
                [character.node runAction:rotate];
            }
            
            moveDirection = cc3v(speed/sqrt(2.0f), 0, speed/sqrt(2.0f));
            character.direction = Other;
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
    CGPoint tile = [[Map myMap] locationInMapWithPosition:CGPointMake(character.node.location.x, character.node.location.z)];
    
    NSLog(@"%c" , [[Map myMap] contentOfMapAtLocation:tile]);
}


#pragma mark - CollisionHandling
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
 * The effect is to see the player collide with a wall, and stop.
 *
 * If the player collides with another player a invoke a method to handle that special case.
 *
 */
-(void) checkForCollisions
{
    if (self.collisionEnabled)
    {
        //For each player
        for (Player *player in _playerArray)
        {
            // Test whether the player intersects the wall.
            if (![player.node shouldMove: player.direction])
            {
                //If the player should not move it is intersecting the wall
                [player.node stopAllActions];
                player.node.location = player.oldLocation;
            }
            
            
            //check if he's going over a coin
            CGPoint position = CGPointMake(player.node.location.x, player.node.location.z);
            CGPoint locationTile = [[Map myMap] locationInMapWithPosition:position];
            
//            GLfloat radius = ((CC3NodeSphericalBoundingVolume*)player.node.boundingVolume).radius * self.scale.x;
            
            CGPoint bounds[10] =    {CGPointMake(locationTile.x -1 , locationTile.y - 1), //UPLEFT
                                    CGPointMake(locationTile.x + 1, locationTile.y - 1), //UPRIGHT
                                    CGPointMake(locationTile.x - 1, locationTile.y + 1), //DOWNLEFT
                                    CGPointMake(locationTile.x  + 1, locationTile.y + 1), //DOWNRIGHT
                                    CGPointMake(locationTile.x         , locationTile.y),     //CENTER
                                    CGPointMake(locationTile.x  +  1   , locationTile.y),   //RIGHT
                                    CGPointMake(locationTile.x         , locationTile.y + 1), //DOWN
                                    CGPointMake(locationTile.x  -1     , locationTile.y),      //LEFT
                                    CGPointMake(locationTile.x         , locationTile.y - 1),  //UP
                                    }; //CENTER

            for (int i = 0; i < 10; i++)
            {
                CGPoint playerLocation = bounds[i];
                
                NSString *coinKey = [NSString stringWithFormat:@"%d-%d", (int)playerLocation.x, (int)playerLocation.y];
                CC3MeshParticle *coin = [_coinDictionary objectForKey:coinKey];
                
                if(coin) {
                    //sound from http://www.freesfx.co.uk
                    [[SimpleAudioEngine sharedEngine] playEffect:@"money.mp3"];
                    
                    [coin setIsAlive:NO];
                    player.playerScore++;
                    [_coinDictionary removeObjectForKey:coinKey];
                }
            }
            
            for (CC3Node *coin in [_bonusCoinCollection children]) {
                if ([player.node doesIntersectBoundingVolume:coin.boundingVolume]) {
                    [_bonusCoinCollection removeChild:coin];
                    
                    player.playerScore += 20;
                    
                    [[SimpleAudioEngine sharedEngine] playEffect:@"bell.mp3"];
                }
            }
            //For each player
            for (Player *player2 in _playerArray)
            {
                //add check to see if both of the players are connected
                if (player2 != player && player2.index < [[[Connection myConnection] peerArray] count] && player.index < [[[Connection myConnection] peerArray] count])
                {
                    // Test whether player1 is intersecting player2.
                    if ([player.node.boundingVolume doesIntersect:player2.node.boundingVolume])
                    {
                        NSDate *lastCollision = ([player.lastPlayerCollisionTimestamp objectForKey:[NSString stringWithFormat:@"%d", player2.index]]);
                        NSTimeInterval interval = -[lastCollision timeIntervalSinceNow];
                        if (interval > COLISSION_CHECK_INTERVAL)

                        {
                            // Set timestamp on both players: this way player collision won't be handled twice (P1 touching P2 = P2 touching P1).
                            NSDate *now = [[NSDate date] copy];
                            [player.lastPlayerCollisionTimestamp setObject:now forKey: [NSString stringWithFormat: @"%d", player2.index ]];
                            [player2.lastPlayerCollisionTimestamp setObject:now forKey: [NSString stringWithFormat: @"%d", player.index ]];
                            [[Game myGame] startMinigame: @[player, player2]];
                        }
                        else
                        {
                        }
                    }
                }
            }
            
            player.oldLocation = player.node.location;
        }
    }
    else
    {
        return;
    }
}



@end

