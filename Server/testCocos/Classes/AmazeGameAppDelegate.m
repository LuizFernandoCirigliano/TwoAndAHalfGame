/**
 *  AmazeGameAppDelegate.m
 *  AmazeGame
 *
 *  Created by Luiz Fernando 2 on 1/20/14.
 *  Copyright Luiz Fernando 2 2014. All rights reserved.
 */

#import "AmazeGameAppDelegate.h"
#import "AmazeGameLayer.h"
#import "AmazeGameScene.h"
#import "CC3CC2Extensions.h"
#import "Game.h"

#define kAnimationFrameRate		60		// Animation frame rate

CC3DeviceCameraOverlayUIViewController* _viewController;

@implementation AmazeGameAppDelegate

- (void)dealloc {
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    LogInfo(@"applicationDidReceiveMemoryWarning");
    [[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
    [[CCDirector sharedDirector] stopAnimation];
    
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
    [[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    CCDirector *director = [CCDirector sharedDirector];
    
    [[director openGLView] removeFromSuperview];
    
    [director end];
    
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
    [[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

@end
