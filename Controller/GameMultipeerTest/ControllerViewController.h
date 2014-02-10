//
//  ControllerViewController.h
//  AmazeGameController
//
//  Created by Luiz Fernando 2 on 1/16/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"

@interface ControllerViewController : UIViewController <GameControllerDelegate>


-(void) startMinigame;
-(void) endGame;

@end
