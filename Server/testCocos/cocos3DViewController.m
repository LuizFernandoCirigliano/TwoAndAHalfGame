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
{
    CC3Layer                                    *cc3Layer;
    CC3DeviceCameraOverlayUIViewController      *director;
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
    [self setupCocos3D];
}

-(void) setupCocos3D
{
    // Establish the view controller and CCDirector (in cocos2d 2.x, these are one and the same)
    //[self establishDirectorController];
    director = CC3DeviceCameraOverlayUIViewController.sharedDirector;
    director.supportedInterfaceOrientations = UIInterfaceOrientationMaskAll;
    director.viewShouldUseStencilBuffer = NO;        // Set to YES if using shadow volumes
    director.viewPixelSamples = 1;                    // Set to 4 for antialiasing multisampling
    director.animationInterval = (1.0f / kAnimationFrameRate);
    director.displayStats = YES;
    [director enableRetinaDisplay: YES];
    
//    CC3GLView *glView = [CC3GLView viewWithFrame:self.view.bounds
//                                   pixelFormat:kEAGLColorFormatRGB565 depthFormat:0];
    CC3GLView *glView = [CC3GLView viewWithFrame:self.view.bounds pixelFormat:kEAGLColorFormatRGB565 depthFormat:0];
    glView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [director setCcGLView:glView];
    [self.view insertSubview:director.view
                     atIndex:0];
    [self addChildViewController:director];
    
    cc3Layer = [AmazeGameLayer layerWithController:director];
    
    cc3Layer.cc3Scene = [AmazeGameScene scene];
    
    CC3ControllableLayer *mainLayer = cc3Layer;
    
    [director runSceneOnNode:mainLayer];
    
    NSLog(@"View bounds: %f, %f", self.view.bounds.size.width, self.view.bounds.size.height );
    NSLog(@"GL View Bounds: %f, %f",glView.bounds.size.width, glView.bounds.size.height );
    NSLog(@"Director Bounds: %f, %f", director.view.bounds.size.width, director.view.bounds.size.width );
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