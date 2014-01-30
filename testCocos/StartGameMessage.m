//
//  StartGameMessage.m
//  GestureShenanigans
//
//  Created by Luiz Fernando 2 on 11/22/13.
//  Copyright (c) 2013 Luiz Fernando 2. All rights reserved.
//

#import "StartGameMessage.h"

@implementation StartGameMessage

/**
 * Add method description here
 *
 */
- (NSData *)archiveData
{
    return [self archiveDataWithKey:@"startGameMessage"];
}

@end
