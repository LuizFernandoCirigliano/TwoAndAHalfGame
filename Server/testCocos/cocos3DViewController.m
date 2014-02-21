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
#import "PaperBattleScene.h"

#define kAnimationFrameRate		60	

@interface cocos3DViewController () <Cocos3DViewControllerDelegate>
{
    CC3Layer                                    *cc3Layer;
    CC3UIViewController      *director;
}

@end

@implementation cocos3DViewController
- (IBAction)buttonPress:(id)sender {
    if ([CC3UIViewController.sharedDirector isPaused]) {
        [CC3UIViewController.sharedDirector resume];
        [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    } else {
        [CC3UIViewController.sharedDirector pause];
        [self.pauseButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    NSLog(@"TESTE**");
}
- (IBAction)sceneButton:(id)sender {
    static bool scene = YES;

    if(scene) {
        CC3Layer *cc3Layer = [CC3Layer layerWithController:CC3UIViewController.sharedDirector];
        cc3Layer.cc3Scene = [PaperBattleScene scene];
        CC3ControllableLayer *mainLayer = cc3Layer;
        [CC3UIViewController.sharedDirector pushScene:mainLayer];
    } else {
        [CC3UIViewController.sharedDirector popScene];
    }
    
    scene = !scene;
    
}

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
    
    [self.view sendSubviewToBack:glViewController.view];
    // Create the customized CC3Layer that supports 3D rendering.
    
    CC3Layer *cc3Layer = [AmazeGameLayer layerWithController:glViewController];
    
    // Create the customized 3D scene and attach it to the layer.
    // Could also just create this inside the customer layer.
    
    AmazeGameScene *gameScene = [AmazeGameScene scene];
    gameScene.delegate = self;
    
    cc3Layer.cc3Scene = gameScene;
    
    // Assign to a generic variable so we can uncomment options below to play with the capabilities.
    CC3ControllableLayer* mainLayer = cc3Layer;
    // The 3D layer can run either directly in the scene, or it can run as a smaller "sub-window"
    // within any standard CCLayer. So you can have a mostly 2D window, with a smaller 3D window
    // embedded in it.

    // Run the scene.
    
    [Game myGame].mazeScene = mainLayer;
    [glViewController runSceneOnNode:mainLayer];
    

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

-(void) dissmissVC {
    [self dismissViewControllerAnimated:YES completion:NO];
}
- (void)dealloc {
    [_pauseButton release];
    [super dealloc];
}
@end