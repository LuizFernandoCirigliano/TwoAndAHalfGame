/**
 *  testCocosLayer.m
 *  testCocos
 *
 *  Created by Luiz Fernando 2 on 1/20/14.
 *  Copyright Luiz Fernando 2 2014. All rights reserved.
 */

#import "testCocosLayer.h"
#import "testCocosScene.h"
#import "CC3Light.h"

@implementation testCocosLayer 

-(void) dealloc {
    [super dealloc];
}

/**
 * Override to set up your 2D controls and other initial state, and to initialize update processing.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) initializeControls {
	[self scheduleUpdate];
    
    self.isTouchEnabled = YES;
    
//    [self setColor:ccWHITE];
//    [self.cc3Scene setColor:ccWHITE];
    
//    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
}


#pragma mark Updating layer

/**
 * Override to perform set-up activity prior to the scene being opened
 * on the view, such as adding gesture recognizers.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) onOpenCC3Layer {
    NSLog(@"open la") ;

    [self setColor:ccWHITE];
    [self.cc3Scene setColor:ccWHITE];
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
}

/**
 * Override to perform tear-down activity prior to the scene disappearing.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) onCloseCC3Layer {}

/**
 * The ccTouchMoved:withEvent: method is optional for the <CCTouchDelegateProtocol>.
 * The event dispatcher will not dispatch events for which there is no method
 * implementation. Since the touch-move events are both voluminous and seldom used,
 * the implementation of ccTouchMoved:withEvent: has been left out of the default
 * CC3Layer implementation. To receive and handle touch-move events for object
 * picking, uncomment the following method implementation.
 */

//-(void) ccTouchMoved: (UITouch *)touch withEvent: (UIEvent *)event {
//	[self handleTouch: touch ofType: kCCTouchMoved];
//}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch Began");
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

@end
