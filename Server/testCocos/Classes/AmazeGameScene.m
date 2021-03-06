/**
 *  testCocosScene.m
 *  testCocos
 *
 *  Created by Luiz Fernando 2 on 1/20/14.
 *  Copyright Luiz Fernando 2 2014. All rights reserved.
 */

#import "AmazeGameScene.h"
#import "AmazeGameLayer.h"
#import "CC3PODResourceNode.h"
#import "CC3ActionInterval.h"
#import "CC3MeshNode.h"
#import "CC3Camera.h"
#import "CC3Light.h"
#import "CC3Foundation.h"
#import "CC3UtilityMeshNodes.h"
#import "CC3Node+Collision.h"
#import "CCScheduler.h"
#import "CC3BillBoard.h"
#import "CC3ParametricMeshNodes.h"
#import "CC3MeshParticles.h"
#import "Map.h"
#import "Game.h"
#import "SimpleAudioEngine.h"
#import "GameDefines.h"

#define COLLISION_DEBUG 0
@interface AmazeGameScene()

@property (nonatomic) BOOL collisionEnabled;


@end


#define CAMERA_ANGLE cc3v(0.0f,20.0f,15.0f)
#define COLISSION_CHECK_INTERVAL 30.0f
#define playerScale 22

@implementation AmazeGameScene

NSMutableArray *_walls;

CC3Node *_playerModel;

CC3Node *_allCharacters;

CC3Node *_mazeMap;

CC3Node *_bonusCoin;

CC3Node *_bonusCoinCollection;

NSMutableArray *_tempWallsArray;

CC3MeshParticleEmitter *_emitter;

NSMutableDictionary *_coinDictionary;

NSMutableArray *_playerArray;
NSMutableArray *_timersArray;

NSTimer *_cameraPlayersTimer;

BOOL _paused;
BOOL _ended;
BOOL _isFirstOpen;

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
	self.shouldDrawAllWireframeBoxes = YES;
	
	// If you encounter issues creating and adding nodes, or loading models from
	// files, the following line is used to log the full structure of the scene.
	LogInfo(@"The structure of this scene is: %@", [self structureDescription]);
	
	// ------------------------------------------
    
    
    [[Map myMap] readMapFile];
    
    //leave the mazeWalls as the first method
    [self addMazeWalls];
    
    for (int i = 0; i < 4 ; i++) {
        [self addPlayerCharacterWithNumber: i];
    }
    [self addChild:_allCharacters];

    [self createCoinParticles];
    [self addCamera];

    [self createTempWallsAndObjects];
    [self addChild:lamp];
    // Create OpenGL buffers for the vertex arrays to keep things fast and efficient, and to
	// save memory, release the vertex content in main memory because it is now redundant.
	[self createGLBuffers];
    [self releaseRedundantContent];
    
    self.collisionEnabled = YES;
    
    Game *game = [Game myGame];
//    game.hudLayer = (AmazeGameLayer *)self.cc3Layer;
    
    NSInteger introDuration = game.introDuration;
    
    [self performSelector:@selector(zoomCameraOnObject:) withObject:[[_playerArray firstObject] node] afterDelay:introDuration/4];
    [self performSelector:@selector(zoomCameraOnObject:) withObject:[[_playerArray lastObject] node] afterDelay:introDuration/2];
    [self performSelector:@selector(zoomCameraOnObject:) withObject:self afterDelay:introDuration*3/4];
    [self performSelector:@selector(startZoomingOnPlayers) withObject:nil  afterDelay:introDuration];
    
    [[[CCDirector sharedDirector] scheduler] scheduleBlockForKey:@"start" target:self interval:0 repeat:NO delay:introDuration paused:NO block:^(ccTime time){
        NSLog(@"unpause");
        _paused = NO;
    }];
    
    [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(addBonusCoin) forTarget:self interval:20.0f paused:NO];
    [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(removeWall) forTarget:self interval:10.0f paused:NO];
}

/**
 * This handles initialization for instance variables and properties
 */

-(void) performInitializations {
    
    _allCharacters = [CC3Node node];
    
    
    _walls = [[NSMutableArray alloc] init]; //DO NOT USE [NSMutableArray array], if you do the app WILL crash.
    _tempWallsArray = [[NSMutableArray alloc ] init];
    _paused = YES;
    _isFirstOpen = YES;
    self.flip = NO;
    self.isTouchEnabled = NO;
    
    [[Game myGame] configureGame];
    
    _playerArray = [[Game myGame] playerArray];
    _timersArray = [[NSMutableArray alloc] init];
    _coinDictionary = [[NSMutableDictionary alloc] init];
    
    _bonusCoinCollection  = [CC3Node node];
    [self addChild:_bonusCoinCollection];
    
    [self addContentFromPODFile:@"coin.pod" withName:@"bonusCoinModel"];
    _bonusCoin = [[self getNodeNamed:@"bonusCoinModel"] copy];
    _bonusCoin.scale = cc3v(70,70,70);
    [_bonusCoin createBoundingVolumeFromBoundingBox];
    _bonusCoin.shouldUseFixedBoundingVolume = YES;
    _ended = NO;
    [self removeChild:[self getNodeNamed:@"bonusCoinModel"]];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

/**
 * This method spawns the smaller coins as particle cubes.
 * A coin in spawn in each empty tile using particle system
 * The "collision" is done using a dictionary to check if the coin on that position has been picked up
 */

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

/**
 * This method spawns the removable doors and other scenery objects
 * Positions are defined on the 2d txt map
 */
-(void) createTempWallsAndObjects {
    CC3MeshNode *cube = [CC3MeshNode node];
    
    float sizeX = [[Map myMap] tileSizeX];
    float sizeZ = [[Map myMap] tileSizeZ];
    
    [cube populateAsSolidBox:CC3BoxMake(0, 0, 0, sizeX, 150, sizeZ)];
    
    [self addContentFromPODFile:@"cadeira_mesa.pod" withName:@"caideraMesa"];
    CC3Node *mesaModel = [self getNodeNamed:@"caideraMesa"];
    
    [self addContentFromPODFile:@"shelf.pod" withName:@"shelf"];
    CC3Node *shelfModel = [self getNodeNamed:@"shelf"];
    
    [self addContentFromPODFile:@"mesa.pod" withName:@"mesa"];
    CC3Node *mesaModelLib = [self getNodeNamed:@"mesa"];
    
    [self addContentFromPODFile:@"cesta.pod" withName:@"cesta"];
    CC3Node *cestaModel = [self getNodeNamed:@"cesta"];
    
    [self addContentFromPODFile:@"bleacher4.pod" withName:@"bleacher"];
    CC3Node *bleacherModel = [self getNodeNamed:@"bleacher"];
    
    int xTileCount = [[Map myMap] xTileCount];
    int zTileCount = [[Map myMap] zTileCount];
    
    for (int i = 0; i < xTileCount; i++) {
        for (int j = 0; j < zTileCount; j++) {

            char content = [[Map myMap] contentOfMapAtLocation:CGPointMake(i, j)];
            if (content == '2') {
                CGPoint position = [[Map myMap] positionInMapWithLocation:CGPointMake(i, j)];
                CC3Vector pos = cc3v(position.x - [[Map myMap] tileSizeX]/2, 0, position.y - [[Map myMap] tileSizeZ]/2);
                CC3MeshNode *newCube = [cube copy];
                newCube.location = pos;
                
                [_tempWallsArray addObject:newCube];
                [self addChild:newCube];
                
            } else if (content == '3') {
                [self addContentFromPODFile:@"big_mesa.pod" withName:@"bigMesa"];
                CC3Node *mesa = [self getNodeNamed:@"bigMesa"];
                mesa.scale = cc3v(40,40,40);
                mesa.rotationAngle = 180;
                CGPoint position = [[Map myMap] positionInMapWithLocation:CGPointMake(i, j)];
                CC3Vector pos = cc3v(position.x, 0, position.y);
                
                mesa.location = pos;
                [self addChild:mesa];
            } else if (content == '4') {
                CC3Node *mesa = [mesaModel copy];
                mesa.scale = cc3v(40,40,40);
//                mesa.rotationAngle = 180;
                CGPoint position = [[Map myMap] positionInMapWithLocation:CGPointMake(i, j)];
                CC3Vector pos = cc3v(position.x, 0, position.y);
                
                mesa.location = pos;
                [self addChild:mesa];
            } else if (content == '5') {
                [self addContentFromPODFile:@"lousa.pod" withName:@"lousa"];
                CC3Node *mesa = [self getNodeNamed:@"lousa"];
                mesa.scale = cc3v(30,30,30);
                mesa.rotationAngle = 180;
                CGPoint position = [[Map myMap] positionInMapWithLocation:CGPointMake(i, j)];
                CC3Vector pos = cc3v(position.x, 0, position.y);
                
                [self addChild:mesa];
                mesa.location = pos;
            } else if (content == '6') {
                CC3Node *mesa = [shelfModel copy];
                
                mesa.scale = cc3v(40,40,40);

                CGPoint position = [[Map myMap] positionInMapWithLocation:CGPointMake(i, j)];
                CC3Vector pos = cc3v(position.x, 0, position.y);
                
                mesa.location = pos;
                [self addChild:mesa];
            } else if (content == '7') {
                CC3Node *mesa = [mesaModelLib copy];
                
                mesa.scale = cc3v(40,40,40);
                mesa.rotationAngle = 180;
                CGPoint position = [[Map myMap] positionInMapWithLocation:CGPointMake(i, j)];
                CC3Vector pos = cc3v(position.x, 0, position.y);
                
                mesa.location = pos;
                [self addChild:mesa];
            } else if (content == '8') {
                CC3Node *mesa = [cestaModel copy];
                mesa.scale = cc3v(45,45,45);
                mesa.rotationAxis = kCC3VectorUnitYPositive;
                mesa.rotationAngle = 180;

                CGPoint position = [[Map myMap] positionInMapWithLocation:CGPointMake(i, j)];
                CC3Vector pos = cc3v(position.x, 0, position.y);
                
                mesa.location = pos;
                [self addChild:mesa];
            } else if (content == '9') {
                CC3Node *mesa = [bleacherModel copy];
                
                mesa.scale = cc3v(20,20,20);
                mesa.rotationAngle = 180;
                CGPoint position = [[Map myMap] positionInMapWithLocation:CGPointMake(i, j)];
                CC3Vector pos = cc3v(position.x, 0, position.y);
                
                mesa.location = pos;
                [self addChild:mesa];
            } else if (content == 'l') {
                [self addContentFromPODFile:@"quadra.pod" withName:@"quadra"];
                CC3Node *mesa = [self getNodeNamed:@"quadra"];
                mesa.scale = cc3v(20,20,20);
                mesa.rotationAngle = 180;
                CGPoint position = [[Map myMap] positionInMapWithLocation:CGPointMake(i, j)];
                CC3Vector pos = cc3v(position.x, 10, position.y);
                
                mesa.location = pos;
                [self addChild:mesa];
            } else if (content == 'f') {
                CC3Node *mesa = [cestaModel copy];
                
                mesa.scale = cc3v(45,45,45);
                mesa.rotationAxis = kCC3VectorUnitYPositive;
                mesa.rotationAngle = 0;
                
                CGPoint position = [[Map myMap] positionInMapWithLocation:CGPointMake(i, j)];
                CC3Vector pos = cc3v(position.x, 0, position.y);
                
                mesa.location = pos;
                [self addChild:mesa];
            }
        }
    }

}


/**
 * Create the camera and add it to the scene
 */

-(void) addCamera {
    // Create the camera, place it back a bit, and add it to the scene
	CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
    cam.location = cc3v(0,0, 10000);
    cam.targetLocation = cc3v(0, 10, 0);
    
    cam.hasInfiniteDepthOfField = YES;
    cam.nearClippingDistance = 1000;
	[self addChild: cam];
}



/**
 * Load the 3d model of the map and add it to scene
 * On this case the object for the entrance is added separately
 */

-(void) addMazeWalls {
    //Add maze map mesh
    [self addContentFromPODFile: schoolMapModel withName:@"school"];
    _mazeMap = [self getNodeNamed:@"school"];

    _mazeMap.scale = cc3v(200,200,200);
    

    [[Map myMap] setSizesWithMapX:_mazeMap.boundingBox.maximum.x*_mazeMap.scale.x*2  andMapZ:_mazeMap.boundingBox.maximum.z*2*_mazeMap.scale.z];
    [[Map myMap] setScale:200];
    
    [self addChild:_mazeMap];
    
    [self addContentFromPODFile: schoolEntranceModel withName:@"schoolEntrance"];
    CC3Node *entrance = [self getNodeNamed:@"schoolEntrance"];
    
    entrance.scale = cc3v(200, 200, 200);
    entrance.location = cc3v(-entrance.boundingBox.maximum.x*entrance.scale.x/2, 0, [[Map myMap] mapSizeZ] / 2 + entrance.boundingBox.maximum.z*entrance.scale.z*2.5/3);
}

/**
 * This method is called periodically and spawns a bigger coin on a random spot.
 * This coin is worth more points
 */
-(void) addBonusCoin {
    
    if (!_paused) {
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
        
        [_bonusCoinCollection addChild:coin];
    }
}

/**
 * Creates a new player instance with a player index
 * Creates a node for the character and adds it to scene
 * Adds a billboard on top of the player to display the number
 */

-(void) addPlayerCharacterWithNumber:(NSInteger) number
{
    Player *player = [[Player alloc] initWithIndex: number];
    
    NSString *modelString;
    switch (number) {
        case 0:
            modelString = sergioModel;
            break;
        case 2:
        case 3:
            
            modelString = boyModel;
            break;
        
        case 1:
            modelString = reinaModel;
            break;
        default:
            modelString = boyModel;
            break;
    }
    //copy the original model
    [self addContentFromPODFile:modelString withName:[NSString stringWithFormat:@"player%d",number]];
    CC3Node *characterModel = [self getNodeNamed:[NSString stringWithFormat:@"player%d",number]];
    
    player.originalNode = [characterModel copy];
    CC3Node *character = [characterModel copy];
    
    //create bounding volume
    [character createSphericalBoundingVolumeFromBoundingBoxWithRadiusRatio:0.3f];
    
#if COLLISION_DEBUG
    character.shouldDrawBoundingVolume = YES;
#endif
    
    //temporary spawn position methods, replace with positions on map text file
    CGPoint spawnPoint;
    switch ([_playerArray count]) {
        case 0:
            spawnPoint = [[Map myMap] positionInMapWithLocation:CGPointMake(2,2)];
            break;
        case 1:
            spawnPoint = [[Map myMap] positionInMapWithLocation:CGPointMake(58,38)];
            break;
        case 2:
            spawnPoint = [[Map myMap] positionInMapWithLocation:CGPointMake(2,38)];
            break;
        case 3:
            spawnPoint = [[Map myMap] positionInMapWithLocation:CGPointMake(58,2)];
            break;
        default:
            spawnPoint = CGPointMake(0, 0);
            break;
    }
    
    character.location = cc3v(spawnPoint.x - [[Map myMap] tileSizeX]/2, 0 , spawnPoint.y - [[Map myMap] tileSizeZ]/2) ;
    
    character.rotationAxis = kCC3VectorUnitYPositive;
    character.scale = cc3v(playerScale, playerScale, playerScale);
    
    //Add Identifier on Player
    //Make a 2D sprite with image = player's number
    CCSprite *markerSprite = [CCSprite spriteWithFile: [NSString stringWithFormat:@"p%d.png", number+1]];
    //Add sprite to billboard
    CC3Billboard *marker = [CC3Billboard nodeWithName: @"TouchSpot" withBillboard: markerSprite];
    [marker setScale:cc3v(0.2f, 0.2f, 0.2f)];
    marker.location = cc3v(0,25,0);
    //Always face the camera
    
    marker.shouldAutotargetCamera = YES;
    [marker setIsTouchEnabled:NO];
    
    [character addChild:marker];

    player.node = character;
    
    //add to character array and add the node to the scene
    [_playerArray addObject:player];
    
    [_allCharacters addChild:character];

    player.delegate = self;
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
    
    if ([Game myGame].roundDuration == 0 && !_ended) {
        _ended = YES;
        [self endGame];
    }

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
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"funky_music.wav" loop:YES];
    
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
    
    if (!_isFirstOpen) {
        _paused = NO;
    }
    _isFirstOpen = NO;
    
    
    [Connection myConnection].delegate = self;
    
	// Uncomment this line to draw the bounding box of the scene.
//	self.shouldDrawWireframeBox = YES;
}


/**
 * Method called when the game ends.
 * Zooms in on the winner and displays message.
 */
-(void) endGame
{
    for (NSTimer *timer in _timersArray) {
        [timer invalidate];
    }
    
    
    [self pauseAllActions];
    Player *winner = [[Game myGame] topScorer];
    
    self.collisionEnabled = NO;
    winner.node.location = cc3v(winner.node.location.x, 300, winner.node.location.z);
    winner.node.scale = cc3v(2*playerScale, 2*playerScale, 2*playerScale);
    
    //focus camera on the winner
    [self.activeCamera moveWithDuration:1.0f toShowAllOf:winner.node fromDirection:cc3v(0, 0, 1)];
    self.activeCamera.target = winner.node;
    self.activeCamera.shouldTrackTarget = YES;
    
    [winner.node stopAllActions];
    //animations to run on the winning player
    [winner.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
    CCActionInterval *rotateAction = [CC3RotateByAngle actionWithDuration:1.0f rotateByAngle:-30.0f];
    [winner.node runAction:[CCRepeatForever actionWithAction:rotateAction]];
    
    //display player winner message
    [[[Game myGame] hudLayer] displayWinnerMessageWithNumber:winner.index];
    
    //warn the controllers that the game is over
    NSData *data = [[[EndRoundMessage alloc] init] archiveData];
    [[Connection myConnection] sendData:data];

    [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(closeScene) userInfo:nil repeats:NO];
}

-(void) closeScene {
    [[CCDirector sharedDirector] replaceScene:[CCScene node]];
    [CC3Resource removeAllResources];
    
    if([self.delegate respondsToSelector:@selector(dissmissVC)])
        [self.delegate dissmissVC];
}

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene has been removed from display.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onClose {
   [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    _paused = YES;
}

/**
 * Removes a random wall block.
 */
-(void) removeWall
{
    if ([_tempWallsArray count] > 0 && !_paused) {
        CC3Node *tempWall = [_tempWallsArray firstObject];
        CGPoint position = CGPointMake(tempWall.location.x, tempWall.location.z);
        CGPoint location = [[Map myMap] locationInMapWithPosition:position];

        [self removeChild:tempWall];
        [[Map myMap] replaceAtLocation:location withChar:'0'];
        [_tempWallsArray removeObject:tempWall];
        
    }
}

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

#pragma mark - GameConnectionDelegate
//Methods that handle multipeer controller interaction
/**
 * Delegate method called when a button is pressed by a player.
 *
 \param buttonPressMessage The button press message
 */
-(void) otherPlayerPressed:(ButtonPressMessage *)buttonPressMessage
{
    
    if ([[buttonPressMessage playerNumber] intValue] >= [_playerArray count] || _paused)
    {
        return;
    }
    
    
    Player* player = [_playerArray objectAtIndex:[[buttonPressMessage playerNumber] intValue]];
    int buttonNumberInt = [[buttonPressMessage buttonNumber] intValue];
    
    
    if (player.state != FROZEN) {
    
        CC3Vector moveDirection;
        CCActionInterval *move;
        
        int teleportTarget, speed;
        if (player.state == SPRINT)
            speed = 50;
        else
            speed = 30;
        //sets the direction of movement based on the number passed by the connexion, rotates the dragon to face the direction of movement.

        //sets the direction of movement based on the number passed by the connexion, rotates the dragon to face the direction of movement.
        switch (buttonNumberInt)
        {
            //up button
            case 2:
                if(player.node.rotationAngle != 0)
                {
                    CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:0];
                    [player.node runAction:rotate];
                }
                moveDirection = cc3v(0, 0, speed);
                player.direction = Up;
                move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
                [player.node runAction:[CCRepeatForever actionWithAction:move] withTag:0];
                [player.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];

                break;
            //right button
            case 3:
                if(player.node.rotationAngle != -90)
                {
                    CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:-90];
                    [player.node runAction:rotate];
                }
                moveDirection = cc3v(-speed, 0, 0);
                player.direction = Right;
                move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
                [player.node runAction:[CCRepeatForever actionWithAction:move] withTag:0];
                [player.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
                
                break;
            //bottom button
            case 0:
                if(player.node.rotationAngle != 180)
                {
                    CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:180];
                    [player.node runAction:rotate];
                }
                
                moveDirection = cc3v(0, 0, -speed);
                player.direction = Down;
                move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
                [player.node runAction:[CCRepeatForever actionWithAction:move] withTag:0];
                [player.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
                break;
            //left button
            case 1:
                if(player.node.rotationAngle != 90)
                {
                    CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:90];
                    [player.node runAction:rotate];
                }
                
                moveDirection = cc3v(speed, 0, 0);
                player.direction = Left;
                move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
                [player.node runAction:[CCRepeatForever actionWithAction:move]withTag:0];
                [player.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
                break;
            //upright button
            case 30:
                if(player.node.rotationAngle != -45)
                {
                    CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:-45];
                    [player.node runAction:rotate];
                }
                
                moveDirection = cc3v(-speed/sqrt(2.0f), 0, speed/sqrt(2.0f));
                player.direction = Other;
                move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
                [player.node runAction:[CCRepeatForever actionWithAction:move]withTag:0];
                [player.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
                break;
            //downright button
            case 40:
                if(player.node.rotationAngle != -135)
                {
                    CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:-135];
                    [player.node runAction:rotate];
                }
                
                moveDirection = cc3v(-speed/sqrt(2.0f), 0, -speed/sqrt(2.0f));
                player.direction = Other;
                move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
                [player.node runAction:[CCRepeatForever actionWithAction:move]withTag:0];
                [player.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
                break;
            //downleft button
            case 10:
                if(player.node.rotationAngle != 135)
                {
                    CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:135];
                    [player.node runAction:rotate];
                }
                
                moveDirection = cc3v(speed/sqrt(2.0f), 0, -speed/sqrt(2.0f));
                move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
                player.direction = Other;
                [player.node runAction:[CCRepeatForever actionWithAction:move]withTag:0];
                [player.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
                break;
            //upleft button
            case 20:
                if(player.node.rotationAngle != 45)
                {
                    CCActionInterval *rotate = [CC3RotateToAngle actionWithDuration:0.5f rotateToAngle:45];
                    [player.node runAction:rotate];
                }
                
                moveDirection = cc3v(speed/sqrt(2.0f), 0, speed/sqrt(2.0f));
                player.direction = Other;
                move = [CC3MoveBy actionWithDuration:0.1f moveBy:moveDirection];
                [player.node runAction:[CCRepeatForever actionWithAction:move]withTag:0];
                [player.node runAction:[CCRepeatForever actionWithAction:[CC3Animate actionWithDuration:1.0f]] withTag:1];
                break;
            
            
            case 100:
                teleportTarget = arc4random()%4;
                if (teleportTarget != player.index) {
                    self.collisionEnabled = NO;
                    Player *targetTeleportPlayer = [_playerArray objectAtIndex: teleportTarget];
                    CC3Vector tempLocation = player.node.location;
                    
                    [targetTeleportPlayer.node stopAllActions];
                    [player.node stopAllActions];
                    
                    player.node.location = targetTeleportPlayer.node.location;
                    targetTeleportPlayer.node.location = tempLocation;
                    self.collisionEnabled = YES;
                }
                break;
            case 200:
                player.state = THIEF;
                break;
            case 300:
                player.state = FREEZER;
                break;
            case 400:
                player.state = SPRINT;
                break;
            //movement end
            default:

                [player.node stopActionByTag:0];
                [player.node stopActionByTag:1];
                break;
        }
    }
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
                    
//                    [[SimpleAudioEngine sharedEngine] playEffect:@"bell.mp3"];
                }
            }
            //For each player
            for (Player *player2 in _playerArray)
            {
                if([player.node.boundingVolume doesIntersect:player2.node.boundingVolume] && player != player2) {
                    if (player.state == THIEF && player2.state != THIEF) {
                        player.playerScore += 20;
                        player2.playerScore -= 20;
                        player.state = NORMAL;
                    }
                    else if (player.state == FREEZER) {
                        player2.state = FROZEN;
                    }
                    //add check to see if both of the players are connected
                    else if (player.state == NORMAL && player2.state == NORMAL && player.index < player2.index && player2.index < [[[Connection myConnection] peerArray] count] && player.index < [[[Connection myConnection] peerArray] count])
                    {
                        // Test whether player1 is intersecting player2.
                        
                            NSDate *lastCollision = ([player.lastPlayerCollisionTimestamp objectForKey:[NSString stringWithFormat:@"%d", player2.index]]);
                            NSTimeInterval interval = -[lastCollision timeIntervalSinceNow];
                            if (interval > COLISSION_CHECK_INTERVAL  && player.isPlayingMinigame == NO && player2.isPlayingMinigame == NO)

                            {
                                // Set timestamp on both players: this way player collision won't be handled twice (P1 touching P2 = P2 touching P1).
                                NSDate *now = [[NSDate date] copy];
                                [player.lastPlayerCollisionTimestamp setObject:now forKey: [NSString stringWithFormat: @"%d", player2.index ]];
                                [player2.lastPlayerCollisionTimestamp setObject:now forKey: [NSString stringWithFormat: @"%d", player.index ]];
                                [[Game myGame] startMinigame: @[player, player2]];
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

#pragma mark - Camera Methods

/**
 * Moves the camera to frame all the players.
 */
-(void) zoomCameraOnPlayers
{
    if (!_paused)
        [self.activeCamera moveWithDuration:0.5f toShowAllOf:_allCharacters fromDirection:CAMERA_ANGLE];
}

/**
 * Moves the camera to frame a specific object
 \param object The object that should be framed by the camera.
 */
-(void) zoomCameraOnObject: (CC3Node *)object {
    NSLog (@"camera luz acao")  ;
    [self.activeCamera moveWithDuration:1.0f toShowAllOf:object fromDirection:CAMERA_ANGLE];
}

/**
 * Creates a 5.0 second-timer that triggers a zoomCameraOnPlayers selector.
 */
- (void) startZoomingOnPlayers
{
    [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(zoomCameraOnPlayers) forTarget:self interval:5.0f paused:NO];
}

#pragma mark - TEST METHODS

/**
 * Creates a test terrain
 */
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

                
                CGPoint position = [[Map myMap] positionInMapWithLocation:CGPointMake(i, j)];
                CC3Vector pos = cc3v(position.x, LOCATION_Z, position.y);
                [tile setLocation: pos];
                [tile retainVertexLocations];
                
                
                [self addChild: tile];
                
            }
        }
    }
}
@end

