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
    Scissors,
    nothing
    
};


@interface Janken : NSObject

/**
 * The ID of the winning player
 */
@property (nonatomic) NSInteger winner;

- (void) player: (NSInteger) playerID chose: (JankenType) playerGesture;

@end
