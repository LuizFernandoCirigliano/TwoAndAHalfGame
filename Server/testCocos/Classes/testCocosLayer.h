/**
 *  testCocosLayer.h
 *  testCocos
 *
 *  Created by Luiz Fernando 2 on 1/20/14.
 *  Copyright Luiz Fernando 2 2014. All rights reserved.
 */


#import "CC3Layer.h"


/** A sample application-specific CC3Layer subclass. */
@interface testCocosLayer : CC3Layer
{
    
}
-(void) displayWinnerMessageWithNumber: (NSInteger) winnerNumber;
-(void) updateHUD;
-(void) displayMiddleLabelWithString: (NSString *) messageString;
@end
