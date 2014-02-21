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


@implementation AmazeGameAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication]
     setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[CC3UIViewController sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[CC3UIViewController sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    LogInfo(@"applicationDidReceiveMemoryWarning");
    [[CC3UIViewController sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
    [[CC3UIViewController sharedDirector] stopAnimation];
    self.taskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^
                   {
                       //
                       //                       [self shutdownMultiPeerStuff];
                   }];
    
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
    [[CC3UIViewController sharedDirector] startAnimation];
    [[UIApplication sharedApplication] endBackgroundTask:self.taskID];
    self.taskID = UIBackgroundTaskInvalid;
    //    [self cancelLocalNotificationAboutMultiPeerSession];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    CC3UIViewController *director = [CC3UIViewController sharedDirector];
    
    [[director openGLView] removeFromSuperview];
    
    [director end];
    
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
    [[CC3UIViewController sharedDirector] setNextDeltaTimeZero:YES];
}

@end
