//
//  Janken.h
//  TwoAndAHalfGame
//
//  Created by Francesco Perrotti-Garcia on 2/4/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kJankenTie -1

typedef NS_ENUM(NSInteger, JankenType)
{
    Rock,
    Paper,
    Scissors
};


@interface Janken : NSObject

/**
 * The ID of player number A
 */
@property (nonatomic) NSInteger playerAID;

/**
 * The ID of player number B
 */
@property (nonatomic) NSInteger playerBID;

/**
 * The gesture of player number A
 */
@property (nonatomic) JankenType playerAGesture;

/**
 * The gesture of player number A
 */
@property (nonatomic) JankenType playerBGesture;

/**
 * The ID of the winning player
 */
@property (nonatomic) NSInteger winner;


@end
