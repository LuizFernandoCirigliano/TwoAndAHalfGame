/**
 *  testCocosAppDelegate.h
 *  testCocos
 *
 *  Created by Luiz Fernando 2 on 1/20/14.
 *  Copyright Luiz Fernando 2 2014. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "CC3DeviceCameraOverlayUIViewController.h"

@interface testCocosAppDelegate : NSObject <UIApplicationDelegate>
{
    /**
     * Add instance variable description here
     *
     */
	UIWindow* _window;
    
    /**
     * Add instance variable description here
     *
     */
	CC3DeviceCameraOverlayUIViewController* _viewController;
}
@end
