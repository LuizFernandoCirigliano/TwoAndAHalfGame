/**
 *  testCocosAppDelegate.h
 *  testCocos
 *
 *  Created by Luiz Fernando 2 on 1/20/14.
 *  Copyright Luiz Fernando 2 2014. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "CC3DeviceCameraOverlayUIViewController.h"

@interface testCocosAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow* _window;
	CC3DeviceCameraOverlayUIViewController* _viewController;
}
@end
