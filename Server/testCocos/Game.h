//
//  Game.h
//  TwoAndAHalfGame
//
//  Created by Luiz Fernando 2 on 2/4/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Janken.h"

@interface Game : NSObject

+(Game *)myGame;

- (void) configureGame;


@property (strong, nonatomic) Janken *janken;
@property (strong, nonatomic) NSMutableArray *playerArray;

@end
