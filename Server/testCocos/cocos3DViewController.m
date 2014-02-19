//
//  cocos3DViewController.m
//  Amaze Game
//
//  Created by Luiz Fernando 2 on 2/14/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "cocos3DViewController.h"
#import "CC3UIViewController.h"
#import "CC3CC2Extensions.h"
#import "AmazeGameLayer.h"
#import "AmazeGameScene.h"
#import "Game.h"

#define kAnimationFrameRate		60	

@interface cocos3DViewController ()
{
    CC3Layer                                    *cc3Layer;
    CC3UIViewController      *director;
}

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

-(id) initWithFrame:(CGRect)frame
{
    self.view.frame = frame;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setupCocos3D];
}

-(void) viewWillAppear:(BOOL)animated {
    [self setupCocos3D];
}

//-(void) setupCocos3D
//{
//    // Establish the view controller and CCDirector (in cocos2d 2.x, these are one and the same)
//    //[self establishDirectorController];
//    director = [[CC3UIViewController alloc] init];
//    director = [CC3UIViewController sharedDirector];
//    director.supportedInterfaceOrientations = UIInterfaceOrientationMaskAll;
//    director.viewShouldUseStencilBuffer = YES;        // Set to YES if using shadow volumes
//    director.viewPixelSamples = 1;                    // Set to 4 for antialiasing multisampling
//    director.animationInterval = (1.0f / kAnimationFrameRate);
//    director.displayStats = YES;
//    [director enableRetinaDisplay: YES];
//    
////    CC3GLView *glView = [CC3GLView viewWithFrame:self.view.bounds
////                                   pixelFormat:kEAGLColorFormatRGB565 depthFormat:0];
//    CC3GLView *glView = [CC3GLView viewWithFrame:self.view.bounds pixelFormat:kEAGLColorFormatRGB565 depthFormat:0];
////    glView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    
//    [self addChildViewController:director];
//    
//    [director setView: glView];
////    director.openGLView = self.view;
//    [self.view insertSubview:director.view
//                     atIndex:0];
//
//    
//    
//    cc3Layer = [AmazeGameLayer layerWithController:director];
//    
//    cc3Layer.cc3Scene = [AmazeGameScene scene];
//    
//    CC3ControllableLayer *mainLayer = cc3Layer;
//    
//    CCScene *scene = [CCScene node];
//    [scene addChild:mainLayer];
//    [director runWithScene:scene];
//    
//    [Game myGame].viewController = director;
//    
//    NSLog(@"View bounds: %f, %f", self.view.bounds.size.width, self.view.bounds.size.height );
//    NSLog(@"GL View Bounds: %f, %f",glView.bounds.size.width, glView.bounds.size.height );
//    NSLog(@"Director Bounds: %f, %f", director.view.bounds.size.width, director.view.bounds.size.width );
//}

-(void) setupCocos3D {
//    Establish the view controller and CCDirector (in cocos2d 2.x, these are one and the same)
    CC3UIViewController *glViewController = CC3UIViewController.sharedDirector;
    glViewController.supportedInterfaceOrientations = UIInterfaceOrientationMaskAll;
    glViewController.viewShouldUseStencilBuffer = NO;        // Set to YES if using shadow volumes
    glViewController.viewPixelSamples = 1;                    // Set to 4 for antialiasing multisampling
    glViewController.animationInterval = (1.0f / 60.0f);
    glViewController.displayStats = YES;
    [glViewController enableRetinaDisplay: YES];
    glViewController.view.frame = self.view.frame;
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

    // Run the scene.
    [glViewController runSceneOnNode:mainLayer];
    
    [Game myGame].viewController = glViewController;
}

-(BOOL) shouldAutorotate { return YES; }

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end