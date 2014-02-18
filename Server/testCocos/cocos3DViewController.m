//
//  cocos3DViewController.m
//  Amaze Game
//
//  Created by Luiz Fernando 2 on 2/14/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "cocos3DViewController.h"
#import "CCDirector.h"
#import "CC3CC2Extensions.h"

#import "AmazeGameLayer.h"
#import "AmazeGameScene.h"
#import "Game.h"

#define kAnimationFrameRate		60	

@interface cocos3DViewController ()

@end



@implementation cocos3DViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUpCocos3D];
//    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpCocos3D
{
    // Default texture format for PNG/BMP/TIFF/JPEG/GIF images.
    // It can be RGBA8888, RGBA4444, RGB5_A1, RGB565. You can change anytime.
    CCTexture2D.defaultAlphaPixelFormat = kCCTexture2DPixelFormat_RGBA8888;
    
    // Establish the view controller and CCDirector (in cocos2d 2.x, these are one and the same)
    CC3DeviceCameraOverlayUIViewController *glViewController = cc3;
    //self.glViewController.supportedInterfaceOrientations = UIInterfaceOrientationMaskAll;
    glViewController.viewShouldUseStencilBuffer = NO;        // Set to YES if using shadow volumes
    glViewController.viewPixelSamples = 4;                    // Set to 4 for antialiasing multisampling
    glViewController.animationInterval = (1.0f / 60.0f);
    glViewController.displayStats = YES;
    [glViewController enableRetinaDisplay: YES];
    // Add the 3D view to the view cotroller
    [self.view addSubview:glViewController.view];
    // Create the customized CC3Layer that supports 3D rendering.
    CC3Layer *cc3Layer = [AmazeGameLayer layerWithController:glViewController];
    
    // Create the customized 3D scene and attach it to the layer.
    // Could also just create this inside the customer layer.
    cc3Layer.cc3Scene = [AmazeGameScene scene];
    // Assign to a generic variable so we can uncomment options below to play with the capabilities.
    CC3ControllableLayer* mainLayer = cc3Layer;
    // The 3D layer can run either directly in the scene, or it can run as a smaller "sub-window"
    // within any standard CCLayer. So you can have a mostly 2D window, with a smaller 3D window
    // embedded in it.
    cc3Layer.contentSize = CGSizeMake(704.0f, 704.0f);
    
    // Run the scene.
//    [glViewController runSceneOnNode:mainLayer];
}

-(void) setup {
    
    CCDirector *director = [CCDirector sharedDirector];
    
    [director setAnimationInterval:1.0/60];
    [director setDisplayFPS:YES];
    [director enableRetinaDisplay:YES];
    
    EAGLView* eagl = [EAGLView viewWithFrame: CGRectMake(0, 0, 768, 960)
                                 pixelFormat: kEAGLColorFormatRGBA8
                                 depthFormat: GL_DEPTH_COMPONENT16_OES
                          preserveBackbuffer: NO
                                  sharegroup: nil
                               multiSampling: NO
                             numberOfSamples: 4];
    
    [director setOpenGLView:eagl];
    [self.view addSubview:eagl];
    CC3Layer *cc3Layer = [AmazeGameLayer layerWithController:director];
//    [cc3Layer scheduleUpdate];
    CC3Scene *scene = [AmazeGameScene scene];
    cc3Layer.cc3Scene = scene;
//    scene = [CCScene node];
//    [scene addChild: (ControllableCCLayer*)cc3Layer];
    if([director runningScene])
        [director replaceScene:scene];
    else
        [director runWithScene:scene];
}

@end
